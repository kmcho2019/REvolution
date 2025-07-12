module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

wire [31:0] next_q;

assign next_q = {q[30:0], q[31] ^ q[21] ^ q[1] ^ q[0]};

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= {next_q[30:0], next_q[31]};
    end
end

endmodule