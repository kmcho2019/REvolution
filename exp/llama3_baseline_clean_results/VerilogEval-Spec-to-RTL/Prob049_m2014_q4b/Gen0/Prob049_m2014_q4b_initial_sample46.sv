module TopModule (
    input  clk,  // clock
    input  ar,   // asynchronous reset
    input  d,    // data input
    output q      // data output
);

reg q_reg; // internal register to hold the output

// assign output to internal register
assign q = q_reg;

// always block to handle the asynchronous reset and the positive edge of the clock
always @(posedge clk or posedge ar) begin
    if (ar) begin // if asynchronous reset is high, reset the output to 0
        q_reg <= 1'b0;
    end else if (~ar) begin // if asynchronous reset is low, update the output on the positive edge of the clock
        q_reg <= d;
    end
end

endmodule