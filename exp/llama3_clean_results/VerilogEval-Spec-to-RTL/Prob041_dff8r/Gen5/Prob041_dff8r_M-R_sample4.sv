module dff (
    input clk,
    input reset,
    input d,
    output logic q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 1'b0;
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

    dff dff0 (.clk(clk), .reset(reset), .d(d[0]), .q(q[0]));
    dff dff1 (.clk(clk), .reset(reset), .d(d[1]), .q(q[1]));
    dff dff2 (.clk(clk), .reset(reset), .d(d[2]), .q(q[2]));
    dff dff3 (.clk(clk), .reset(reset), .d(d[3]), .q(q[3]));
    dff dff4 (.clk(clk), .reset(reset), .d(d[4]), .q(q[4]));
    dff dff5 (.clk(clk), .reset(reset), .d(d[5]), .q(q[5]));
    dff dff6 (.clk(clk), .reset(reset), .d(d[6]), .q(q[6]));
    dff dff7 (.clk(clk), .reset(reset), .d(d[7]), .q(q[7]));

endmodule