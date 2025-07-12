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
    
    // Pipeline stage 1
    reg [15:0] stage1_pp;  // Partial product
    reg [15:0] stage1_mc;  // Multiplicand
    reg [15:0] stage1_mp;  // Multiplier
    reg stage1_valid;
    
    // Shared arithmetic unit
    wire [15:0] add_result = p + stage1_pp;
    wire [15:0] sub_result = p - stage1_pp;
    wire [15:0] add2_result = p + (stage1_pp << 1);
    wire [15:0] sub2_result = p - (stage1_pp << 1);
    
    // Clock gating
    wire clk_gated = clk & (~rdy | reset);

    always @(posedge clk_gated or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
            prev_bit <= 1'b0;
            stage1_valid <= 1'b0;
        end else if (~rdy) begin
            // Pipeline Stage 1: Booth Decoding
            case ({multiplier[1:0], prev_bit})
                3'b000, 3'b111: stage1_pp <= 16'b0;
                3'b001, 3'b010: stage1_pp <= multiplicand;
                3'b011:          stage1_pp <= multiplicand;
                3'b100:         stage1_pp <= multiplicand;
                3'b101, 3'b110: stage1_pp <= multiplicand;
            endcase
            
            stage1_mc <= multiplicand;
            stage1_mp <= multiplier;
            stage1_valid <= (ctr < 4);
            
            // Update multiplier and multiplicand
            multiplier <= {{2{multiplier[15]}}, multiplier[15:2]};
            multiplicand <= multiplicand << 2;
            prev_bit <= multiplier[1];
            
            // Pipeline Stage 2: Accumulation
            if (stage1_valid) begin
                case ({stage1_mp[1:0], prev_bit})
                    3'b000, 3'b111: p <= p;
                    3'b001, 3'b010: p <= add_result;
                    3'b011:        p <= add2_result;
                    3'b100:        p <= sub2_result;
                    3'b101, 3'b110: p <= sub_result;
                endcase
                
                ctr <= ctr + 1;
                rdy <= (ctr == 3);
            end
        end
    end

    // Assertions for verification
    // synthesis translate_off
    always @(posedge clk) begin
        if (reset && (a != 0 || b != 0)) begin
            $display("Reset with non-zero inputs");
        end
        if (rdy && ctr != 4) begin
            $display("Ready signal asserted prematurely");
        end
    end
    // synthesis translate_on

endmodule