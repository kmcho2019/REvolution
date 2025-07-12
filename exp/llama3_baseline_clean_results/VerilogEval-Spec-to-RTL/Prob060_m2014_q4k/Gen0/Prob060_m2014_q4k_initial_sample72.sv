module TopModule (
    input        clk,
    input        resetn,
    input        in,
    output       out
);

reg [3:0] q;

always_ff @(posedge clk) begin
    if (!resetn) begin
        q <= 4'b0000;
    end else begin
        q <= {q[2:0], in};
    end
end

assign out = q[3];

endmodule