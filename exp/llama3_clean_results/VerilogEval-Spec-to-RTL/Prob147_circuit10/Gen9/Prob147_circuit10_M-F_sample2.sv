module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state = 1'b0 // Initialize state to a known value
);

always @(posedge clk) begin
    case({a, b})
        2'b01: state <= 1'b1; // Set state to 1 when a is 0 and b is 1
        2'b11: state <= 1'b0; // Reset state to 0 when a is 1 and b is 1
        default: state <= state; // For other cases, retain the previous state
    endcase
end

assign q = (state == 1'b1) || (a == 1'b1 && b == 1'b0); // Corrected logic for q

endmodule