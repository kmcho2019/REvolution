module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Initialize to 1
    end
    else begin
        // Shift register with custom feedback
        case (q)
            4'b1010: q <= 4'b0001;  // After 10, reset to 1
            4'b0101: q <= 4'b1010;  // Special case for 5->10 transition
            default: q <= {q[2:0], ~q[3]};  // Normal shift with inverted MSB feedback
        endcase
    end
end

endmodule