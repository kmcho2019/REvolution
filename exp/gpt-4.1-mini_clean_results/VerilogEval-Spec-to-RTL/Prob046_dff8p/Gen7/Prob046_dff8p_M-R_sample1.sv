module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Reset value 0x34 = 8'b00110100
    localparam [7:0] RESET_VAL = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_gen
            reg ff;
            always @(negedge clk) begin
                if (reset)
                    ff <= RESET_VAL[i];
                else
                    ff <= d[i];
            end
            assign q[i] = ff;
        end
    endgenerate

endmodule