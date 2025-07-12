module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [2:0] state;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [15:0] product;
    reg [1:0] group_counter;
    reg prev_bit;

    // State definitions
    localparam IDLE = 3'b000;
    localparam INIT = 3'b001;
    localparam COMPUTE = 3'b010;
    localparam DONE = 3'b011;

    // Booth encoding
    wire [2:0] booth_bits;
    wire [15:0] partial_product;
    wire [15:0] multiplicand_x2 = {multiplicand[14:0], 1'b0};

    assign booth_bits = {multiplier[1:0], prev_bit};
    
    assign partial_product = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? 16'b0 :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? multiplicand :
        (booth_bits == 3'b011) ? multiplicand_x2 :
        (booth_bits == 3'b100) ? (~multiplicand_x2 + 1'b1) :
        (~multiplicand + 1'b1);  // For 101,110

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= INIT;
            product <= 16'b0;
            rdy <= 1'b0;
            p <= 16'b0;
            group_counter <= 2'b0;
            prev_bit <= 1'b0;
        end else begin
            case (state)
                INIT: begin
                    // Sign-extend inputs to 16 bits
                    multiplicand <= {{8{a[7]}}, a};
                    multiplier <= {{8{b[7]}}, b};
                    product <= 16'b0;
                    state <= COMPUTE;
                    group_counter <= 2'b0;
                    prev_bit <= 1'b0;
                end
                
                COMPUTE: begin
                    if (group_counter < 4) begin
                        // Accumulate partial product
                        product <= product + partial_product;
                        
                        // Arithmetic shift right by 2 bits
                        multiplier <= {{2{multiplier[15]}}, multiplier[15:2]};
                        prev_bit <= multiplier[1];
                        
                        group_counter <= group_counter + 1;
                    end else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    p <= product;
                    rdy <= 1'b1;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            end case
        end
    end

endmodule