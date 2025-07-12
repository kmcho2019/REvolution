module TopModule(
    input clk,  // clock
    input d,    // input data
    input r,    // reset
    output q     // output
);

reg q_reg;  // internal register for q

always @(posedge clk) begin
    if (r) begin  // if reset is high
        q_reg <= 1'b0;  // reset output to 0
    end else begin
        q_reg <= d;  // update output with input d
    end
end

assign q = q_reg;  // assign internal register to output

endmodule