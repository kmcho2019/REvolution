module TopModule(
    input       clk,
    input       reset,
    input       slowena,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0; // Reset to 0 when reset is high
    end else if (slowena) begin
        if (count == 4'd9) begin
            count <= 4'd0; // Wrap around to 0 after reaching 9
        end else begin
            count <= count + 4'd1; // Increment count when slowena is high
        end
    end
end

assign q = count;

endmodule