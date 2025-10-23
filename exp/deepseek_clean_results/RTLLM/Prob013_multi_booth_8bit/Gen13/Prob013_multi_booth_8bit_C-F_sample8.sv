module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline stage 1 registers
    reg [15:0] stage1_multiplicand;
    reg [15:0] stage1_m2; // precomputed multiplicand*2
    reg [1:0] stage1_counter;
    reg [1:0] stage1_booth_bits;
    reg stage1_valid;

    // Pipeline stage 2 registers
    reg [15:0] stage2_partial;
    reg [15:0] stage2_accum;
    reg [1:0] stage2_counter;
    reg stage2_valid;

    // Booth encoding function (optimized)
    function [15:0] booth_pp;
        input [2:0] bits;
        input [15:0] m;
        input [15:0] m2;
        begin
            case (bits)
                3'b000, 3'b111: booth_pp = 16'b0;
                3'b001, 3'b010: booth_pp = m;
                3'b011:         booth_pp = m2;
                3'b100:         booth_pp = ~m2 + 1'b1;
                default:        booth_pp = ~m + 1'b1; // 101,110
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize pipeline
            stage1_valid <= 1'b0;
            stage2_valid <= 1'b0;
            stage1_counter <= 2'b0;
            stage2_counter <= 2'b0;
            p <= 16'b0;
            rdy <= 1'b0;
            
            // Sign-extend inputs
            stage1_multiplicand <= {{8{a[7]}}, a};
            stage1_m2 <= {{8{a[7]}}, a} << 1;
            stage1_booth_bits <= {b[1:0], 1'b0};
        end else begin
            // Pipeline stage 1: Booth encoding
            if (!rdy) begin
                stage1_valid <= 1'b1;
                
                // Get next 2 bits of multiplier
                case (stage1_counter)
                    2'b00: stage1_booth_bits <= {b[1:0], 1'b0};
                    2'b01: stage1_booth_bits <= {b[3:2], b[1]};
                    2'b10: stage1_booth_bits <= {b[5:4], b[3]};
                    2'b11: stage1_booth_bits <= {b[7:6], b[5]};
                endcase
                
                // Shift multiplicand for next stage
                stage1_multiplicand <= stage1_multiplicand << 2;
                stage1_m2 <= stage1_m2 << 2;
                stage1_counter <= stage1_counter + 1;
            end else begin
                stage1_valid <= 1'b0;
            end

            // Pipeline stage 2: Accumulation
            if (stage1_valid) begin
                stage2_valid <= 1'b1;
                stage2_partial <= booth_pp(stage1_booth_bits, 
                                          stage1_multiplicand, 
                                          stage1_m2);
                
                // Shift partial product based on counter
                case (stage1_counter)
                    2'b01: stage2_partial <= stage2_partial << 2;
                    2'b10: stage2_partial <= stage2_partial << 4;
                    2'b11: stage2_partial <= stage2_partial << 6;
                    default: stage2_partial <= stage2_partial; // 2'b00
                endcase
                
                stage2_accum <= stage2_accum + stage2_partial;
                stage2_counter <= stage1_counter;
            end else begin
                stage2_valid <= 1'b0;
            end

            // Output stage
            if (stage2_valid && stage2_counter == 2'b11) begin
                p <= stage2_accum;
                rdy <= 1'b1;
            end else begin
                rdy <= 1'b0;
            end
        end
    end

endmodule