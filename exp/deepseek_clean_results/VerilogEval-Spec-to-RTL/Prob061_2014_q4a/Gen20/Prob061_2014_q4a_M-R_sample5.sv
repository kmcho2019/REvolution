module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire load_condition = L;
wire shift_condition = E && !L;  // Shift only if not loading
wire next_Q = load_condition ? R : 
              shift_condition ? w : 
              Q;  // Default hold value

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule