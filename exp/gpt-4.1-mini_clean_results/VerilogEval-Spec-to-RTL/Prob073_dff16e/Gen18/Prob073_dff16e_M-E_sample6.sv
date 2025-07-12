module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

reg [7:0] q_lower;
reg [7:0] q_upper;

always @(posedge clk) begin
    if (!resetn) begin
        q_lower <= 8'b0;
        q_upper <= 8'b0;
    end else begin
        if (byteena[0])
            q_lower <= d[7:0];
        // else retain previous q_lower

        if (byteena[1])
            q_upper <= d[15:8];
        // else retain previous q_upper
    end
end

always @(*) begin
    q = {q_upper, q_lower};
end

endmodule