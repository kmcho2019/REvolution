module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0; // Reset to 0 when reset is high
    end else begin
        if (count == 4'd15) begin
            count <= 4'd0; // Wrap around to 0 after 15
        end else begin
            count <= count + 1; // Increment the count
        end
    end
end

assign q = count; // Assign the current count to the output

endmodule