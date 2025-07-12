module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] sr = 2'b00;

always @(negedge aresetn or posedge clk) begin
    if (!aresetn) sr <= 2'b00;
    else sr <= {sr[0], x};
end

assign z = (sr == 2'b10) && x;

endmodule