module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] sr;

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        sr <= 2'b00;
    end else begin
        sr <= {sr[0], x};
    end
end

assign z = (sr == 2'b10) && x;

endmodule