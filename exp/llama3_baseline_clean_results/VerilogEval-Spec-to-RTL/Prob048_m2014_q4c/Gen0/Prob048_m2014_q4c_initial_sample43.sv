module TopModule(
    input  clk,  // clock signal
    input  d,    // data input
    input  r,    // reset signal
    output q      // output
);

reg q_reg; // internal register for output
assign q = q_reg; // assign output to internal register

always @(posedge clk) begin
    if (r) begin // if reset is high
        q_reg <= 0; // reset output to 0
    end else begin
        q_reg <= d; // store input 'd' in internal register
    end
end

endmodule