module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State machine definitions
    localparam IDLE = 2'b00;
    localparam CALCULATE = 2'b01;
    localparam DONE = 2'b10;
    
    reg [1:0] state, next_state;
    reg [3:0] counter;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    wire [15:0] partial_products [0:3];
    wire [15:0] sum_intermediate [0:1];
    
    // State machine transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counter <= 0;
            rdy <= 0;
            p <= 0;
            multiplicand <= 0;
            multiplier <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    multiplicand <= {{8{a[7]}}, a};
                    multiplier <= {{8{b[7]}}, b};
                    counter <= 0;
                    rdy <= 0;
                end
                
                CALCULATE: begin
                    counter <= counter + 1;
                    if (counter == 3) begin
                        p <= sum_intermediate[0] + sum_intermediate[1];
                    end
                end
                
                DONE: begin
                    rdy <= 1;
                end
            endcase
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = CALCULATE;
            CALCULATE: next_state = (counter == 3) ? DONE : CALCULATE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    // Booth encoding and partial product generation
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : pp_gen
            wire [2:0] booth_bits;
            wire [15:0] m2 = {multiplicand[14:0], 1'b0};
            
            assign booth_bits = (i == 0) ? {multiplier[1:0], 1'b0} :
                               (i == 1) ? {multiplier[3:2], multiplier[1]} :
                               (i == 2) ? {multiplier[5:4], multiplier[3]} :
                                          {multiplier[7:6], multiplier[5]};
            
            assign partial_products[i] = 
                (booth_bits == 3'b000 || booth_bits == 3'b111) ? 16'b0 :
                (booth_bits == 3'b001 || booth_bits == 3'b010) ? multiplicand :
                (booth_bits == 3'b011) ? m2 :
                (booth_bits == 3'b100) ? ~m2 + 1'b1 :
                                         ~multiplicand + 1'b1;
        end
    endgenerate
    
    // Shift partial products appropriately
    wire [15:0] shifted_pp [0:3];
    assign shifted_pp[0] = partial_products[0];
    assign shifted_pp[1] = partial_products[1] << 2;
    assign shifted_pp[2] = partial_products[2] << 4;
    assign shifted_pp[3] = partial_products[3] << 6;
    
    // Parallel adder tree
    assign sum_intermediate[0] = shifted_pp[0] + shifted_pp[1];
    assign sum_intermediate[1] = shifted_pp[2] + shifted_pp[3];

endmodule