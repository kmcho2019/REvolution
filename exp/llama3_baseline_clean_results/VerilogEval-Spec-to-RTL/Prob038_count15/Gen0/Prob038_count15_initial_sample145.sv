module TopModule (
    input       clk,        // clock signal
    input       reset,      // active high reset signal
    output [3:0] q          // 4-bit output
);

reg [3:0] count;            // internal 4-bit register to store the count

always @(posedge clk) begin
    if (reset) begin        // if reset is high, reset the count to 0
        count <= 4'd0;
    end else begin          // otherwise, increment the count
        count <= count + 1;
    end
end

assign q = count;           // assign the internal count to the output

endmodule