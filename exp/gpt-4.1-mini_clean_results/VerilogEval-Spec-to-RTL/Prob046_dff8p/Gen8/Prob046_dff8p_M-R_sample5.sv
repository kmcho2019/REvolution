module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    localparam [7:0] RESET_VAL = 8'h34;
    reg [7:0] q_reg;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_loop
            always @(negedge clk) begin
                if (reset)
                    q_reg[i] <= RESET_VAL[i];
                else
                    q_reg[i] <= d[i];
            end
        end
    endgenerate

    assign q = q_reg;
endmodule