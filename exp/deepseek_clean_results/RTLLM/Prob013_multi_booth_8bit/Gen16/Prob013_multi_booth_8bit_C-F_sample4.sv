module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline stage 1 registers
    reg [15:0] stage1_mcand;
    reg [15:0] stage1_mplier;
    reg [1:0] stage1_counter;
    reg stage1_prev_bit;
    reg stage1_valid;

    // Pipeline stage 2 registers
    reg [15:0] stage2_partial;
    reg [1:0] stage2_counter;
    reg stage2_valid;

    // Booth encoding function (optimized)
    function [15:0] booth_encode;
        input [2:0] bits;
        input [15:0] mcand;
        begin
            case (bits)
                3'b000, 3'b111: booth_encode = 16'b0;
                3'b001, 3'b010: booth_encode = mcand;
                3'b011: booth_encode = mcand << 1;
                3'b100: booth_encode = -(mcand << 1);
                default: booth_encode = -mcand; // 101,110
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset pipeline
            stage1_valid <= 1'b0;
            stage2_valid <= 1'b0;
            stage1_counter <= 2'b0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            // Pipeline stage 1: Booth encoding
            if (!rdy) begin
                stage1_mcand <= {{8{a[7]}}, a} << (stage1_counter * 2);
                stage1_mplier <= b >> (stage1_counter * 2);
                stage1_prev_bit <= (stage1_counter == 0) ? 1'b0 : stage1_mplier[1];
                stage1_valid <= 1'b1;
                stage1_counter <= stage1_counter + 1;
            end else begin
                stage1_valid <= 1'b0;
            end

            // Pipeline stage 2: Accumulation
            if (stage1_valid) begin
                stage2_partial <= booth_encode(
                    {stage1_mplier[1:0], stage1_prev_bit},
                    {{8{a[7]}}, a}
                );
                stage2_counter <= stage1_counter;
                stage2_valid <= 1'b1;
            end else begin
                stage2_valid <= 1'b0;
            end

            // Output stage
            if (stage2_valid) begin
                p <= p + stage2_partial;
                rdy <= (stage2_counter == 2'b11);
            end
        end
    end

endmodule