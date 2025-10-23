module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);

    // Constant reset value as parameter or localparam
    localparam [7:0] RESET_VAL = 8'h34;

    always @(negedge clk) begin
        if (reset) begin
            q[0] <= RESET_VAL[0];
            q[1] <= RESET_VAL[1];
            q[2] <= RESET_VAL[2];
            q[3] <= RESET_VAL[3];
            q[4] <= RESET_VAL[4];
            q[5] <= RESET_VAL[5];
            q[6] <= RESET_VAL[6];
            q[7] <= RESET_VAL[7];
        end else begin
            q[0] <= d[0];
            q[1] <= d[1];
            q[2] <= d[2];
            q[3] <= d[3];
            q[4] <= d[4];
            q[5] <= d[5];
            q[6] <= d[6];
            q[7] <= d[7];
        end
    end

endmodule