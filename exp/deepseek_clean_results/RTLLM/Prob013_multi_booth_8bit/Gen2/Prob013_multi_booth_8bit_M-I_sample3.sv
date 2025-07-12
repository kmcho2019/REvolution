module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [2:0] ctr;
    reg prev_bit;
    
    // Carry-save registers
    reg [15:0] sum;
    reg [15:0] carry;
    
    // Clock gating control
    wire shift_enable = (ctr < 4) && !reset;
    
    // Shared adder/subtractor
    wire [15:0] add_result = sum + carry + multiplicand;
    wire [15:0] sub_result = sum + carry - multiplicand;
    wire [15:0] add2_result = sum + carry + (multiplicand << 1);
    wire [15:0] sub2_result = sum + carry - (multiplicand << 1);
    
    // Booth encoding
    wire [2:0] booth_bits = {multiplier[1:0], prev_bit};
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            sum <= 16'b0;
            carry <= 16'b0;
            p <= 16'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
            prev_bit <= 1'b0;
        end else begin
            if (ctr < 4) begin
                // First pipeline stage: Booth encoding and operation selection
                case (booth_bits)
                    3'b001, 3'b010: begin
                        sum <= add_result;
                        carry <= 16'b0;
                    end
                    3'b011: begin
                        sum <= add2_result;
                        carry <= 16'b0;
                    end
                    3'b100: begin
                        sum <= sub2_result;
                        carry <= 16'b0;
                    end
                    3'b101, 3'b110: begin
                        sum <= sub_result;
                        carry <= 16'b0;
                    end
                    default: begin
                        sum <= sum + carry;
                        carry <= 16'b0;
                    end
                endcase
                
                // Second pipeline stage: shift operations
                if (shift_enable) begin
                    // Arithmetic right shift multiplier by 2
                    multiplier <= {{2{multiplier[15]}}, multiplier[15:2]};
                    // Left shift multiplicand by 2
                    multiplicand <= multiplicand << 2;
                    prev_bit <= multiplier[1];
                end
                
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                // Final addition and output
                p <= sum + carry;
                rdy <= 1'b1;
            end
        end
    end

endmodule