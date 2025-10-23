module TopModule(
    input       clk,
    input       reset,
    input       slowena,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0; // Reset counter to 0
    end else if (slowena) begin
        if (count == 4'd9) begin
            count <= 4'd0; // Wrap around to 0 after 9
        end else begin
            count <= count + 1'b1; // Increment counter
        end
    end
end

assign q = count; // Assign count to output

endmodule