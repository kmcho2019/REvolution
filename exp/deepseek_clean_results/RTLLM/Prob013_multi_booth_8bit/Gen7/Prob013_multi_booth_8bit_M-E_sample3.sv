module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline stages
    localparam INIT = 2'b00;
    localparam COMP = 2'b01;
    localparam FINISH = 2'b10;

    reg [1:0] stage, next_stage;
    reg [3:0] counter;  // 4 cycles needed for 8-bit Radix-4
    reg zero_flag;
    
    // Data registers
    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // Extended with sign bit
    reg [15:0] product;
    reg prev_bit;
    
    // Booth encoding wires
    wire [2:0] booth_bits = {multiplier[1:0], prev_bit};
    wire [15:0] pp_select;
    
    // Partial product selection
    assign pp_select = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? 16'b0 :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? multiplicand :
        (booth_bits == 3'b011) ? (multiplicand << 1) :
        (booth_bits == 3'b100) ? -(multiplicand << 1) :
        (booth_bits == 3'b101 || booth_bits == 3'b110) ? -multiplicand : 16'b0;

    // Zero detection
    always @(*) begin
        zero_flag = (a == 8'b0) || (b == 8'b0);
    end

    // Main pipeline control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage <= INIT;
            product <= 16'b0;
            multiplicand <= 16'b0;
            multiplier <= 9'b0;
            prev_bit <= 1'b0;
            counter <= 4'b0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            stage <= next_stage;
            
            case (stage)
                INIT: begin
                    multiplicand <= {{8{a[7]}}, a};
                    multiplier <= {b[7], b};  // Sign extend
                    prev_bit <= 1'b0;
                    product <= 16'b0;
                    counter <= 4'b0;
                    rdy <= 1'b0;
                end
                
                COMP: begin
                    if (!zero_flag) begin
                        // Carry-save addition
                        product <= product + pp_select;
                        // Arithmetic shift right by 2
                        multiplier <= {multiplier[8], multiplier[8], multiplier[8:2]};
                        prev_bit <= multiplier[1];
                        counter <= counter + 1;
                    end
                end
                
                FINISH: begin
                    p <= zero_flag ? 16'b0 : product;
                    rdy <= 1'b1;
                end
            endcase
        end
    end

    // Next stage logic
    always @(*) begin
        case (stage)
            INIT: next_stage = COMP;
            COMP: next_stage = (counter == 4 || zero_flag) ? FINISH : COMP;
            FINISH: next_stage = INIT;
            default: next_stage = INIT;
        endcase
    end

endmodule