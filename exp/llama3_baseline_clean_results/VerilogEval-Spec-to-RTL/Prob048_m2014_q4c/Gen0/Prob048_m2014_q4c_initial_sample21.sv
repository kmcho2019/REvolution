module TopModule(
    input  clk,  // clock
    input  d,    // data input
    input  r,    // reset
    output q     // data output
);

reg q_reg;  // internal register for output q

always @(posedge clk) begin
    if (r) begin
        q_reg <= 1'b0;  // reset q to 0 when r is high
    end else begin
        q_reg <= d;    // set q to d when r is low
    end
end

assign q = q_reg;  // assign output q to internal register q_reg

endmodule