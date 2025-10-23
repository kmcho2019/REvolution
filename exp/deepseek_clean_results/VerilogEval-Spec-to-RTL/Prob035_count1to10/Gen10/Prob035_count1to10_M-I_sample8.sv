module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg wrap_around;

always @(posedge clk) begin
    wrap_around <= (q == 4'b1010);  // Registered comparison for better timing
end

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;               // Direct reset to 1
    end
    else begin
        case (1'b1)
            wrap_around: q <= 4'b0001;  // Wrap around to 1
            default:     q <= q + 4'b0001; // Increment counter
        endcase
    end
end

endmodule