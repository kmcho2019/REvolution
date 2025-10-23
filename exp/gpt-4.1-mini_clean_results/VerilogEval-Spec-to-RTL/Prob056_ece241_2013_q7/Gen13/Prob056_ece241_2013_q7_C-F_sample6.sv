module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j | k) begin
        case ({j, k})
            2'b01: Q <= 1'b0;   // Reset
            2'b10: Q <= 1'b1;   // Set
            2'b11: Q <= ~Q;     // Toggle
            // 2'b00 case excluded since condition (j|k) is false here
        endcase
    end
    // else hold Q (no assignment)
end

endmodule