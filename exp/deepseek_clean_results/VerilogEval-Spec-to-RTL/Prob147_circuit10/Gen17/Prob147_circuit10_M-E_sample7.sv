module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg predictor = 0;  // Predicts whether next output should be active

// Output is 1 when inputs match prediction
assign q = (a & b & predictor) | (~a & ~b & ~predictor);
assign state = predictor;

always @(posedge clk) begin
    // Priority-based state update:
    // 1. Set predictor if current a&b would make q=1 with predictor=1
    // 2. Clear predictor if current a&b would make q=0 with predictor=0
    // 3. Otherwise maintain predictor
    if (a & b) begin
        predictor <= 1'b1;
    end else if (~a & ~b) begin
        predictor <= 1'b0;
    end else begin
        predictor <= (a ^ b) ^ predictor;  // Toggle predictor for mixed inputs
    end
end

endmodule