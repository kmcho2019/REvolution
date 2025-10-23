module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q <= {Q[6:0], S};
    end
end

wire [2:0] addr;
assign addr = {A, B, C};

multiplexer u_mux(
   .d(Q),
   .addr(addr),
   .out(Z)
);

endmodule

module multiplexer(
    input [7:0] d,
    input [2:0] addr,
    output out
);

assign out = d[addr];

endmodule