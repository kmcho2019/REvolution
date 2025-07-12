module DFF(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end else begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

DFF dff(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule