module DFF_sync_reset_posedge (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    // Constant reset value 0x34 = 8'b00110100
    localparam [7:0] RESET_VAL = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dffs
            wire d_bit = d[i];
            wire reset_bit = reset;
            wire q_bit;

            // Implement synchronous reset by muxing reset_val bit on reset
            reg q_reg;
            always @(posedge clk) begin
                if (reset)
                    q_reg <= RESET_VAL[i];
                else
                    q_reg <= d_bit;
            end

            assign q[i] = q_reg;
        end
    endgenerate
endmodule