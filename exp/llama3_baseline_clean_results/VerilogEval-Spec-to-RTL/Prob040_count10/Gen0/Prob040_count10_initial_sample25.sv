module TopModule(
    input  clk,        // clock signal
    input  reset,      // reset signal
    output [3:0] q      // 4-bit output port
);

reg [3:0] count;       // internal 4-bit register for counting

// initialize the counter to 0
initial count = 0;

// synchronous logic, updates on positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        // reset counter to 0 when reset signal is high
        count <= 0;
    end else if (count == 9) begin
        // reset counter to 0 when count exceeds 9
        count <= 0;
    end else begin
        // increment counter
        count <= count + 1;
    end
end

// assign the count value to the output port q
assign q = count;

endmodule