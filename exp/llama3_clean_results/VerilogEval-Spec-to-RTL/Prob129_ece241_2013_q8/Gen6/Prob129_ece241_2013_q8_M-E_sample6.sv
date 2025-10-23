module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [2:0] seq; // 3-bit shift register to capture the last three input values

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        seq <= 3'b000;
    end else begin
        // Shift in the new input and discard the oldest value
        seq <= {seq[1:0], x};
    end
end

// Output logic: Assert z if the captured sequence matches "101"
assign z = (seq == 3'b101);

endmodule