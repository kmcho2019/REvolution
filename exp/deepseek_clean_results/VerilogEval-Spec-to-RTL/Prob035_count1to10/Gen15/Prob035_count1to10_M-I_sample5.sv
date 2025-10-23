module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire wrap_condition = (q == 4'b1010);  // Explicit check for 10
wire [3:0] next_q = wrap_condition ? 4'b0001 : (q + 1);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;          // Direct synchronous reset
    end
    else begin
        q <= next_q;           // Use pre-computed next value
    end
end

// Optional: Gray code conversion (uncomment for power optimization)
// Note: This requires modifying the wrap condition check
// wire [3:0] gray_q;
// binary_to_gray bg(.binary(q), .gray(gray_q));
// assign q_out = gray_q;  // If Gray code output is acceptable

endmodule