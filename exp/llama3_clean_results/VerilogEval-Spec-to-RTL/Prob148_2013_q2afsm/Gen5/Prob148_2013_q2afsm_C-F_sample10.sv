module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state; // Using 2-bit state encoding: A = 2'b00, B = 2'b01, C = 2'b10
reg [1:0] next_state;

always @(*) begin
    case (state)
        2'b00: begin // State A
            if (r[0]) next_state = 2'b01; // Highest priority to device 0
            else if (r[1]) next_state = 2'b10; // Next priority to device 1
            else if (r[2]) next_state = 2'b00; // Lowest priority to device 2, stay in A
            else next_state = 2'b00; // No requests, stay in A
        end
        2'b01: next_state = r[0] ? 2'b01 : 2'b00; // Stay in B if r0 is 1, else go to A
        2'b10: next_state = r[1] ? 2'b10 : 2'b00; // Stay in C if r1 is 1, else go to A
        default: next_state = 2'b00; // Default to state A
    endcase
end

always @(posedge clk) begin
    if (~resetn) state <= 2'b00; // Reset to state A
    else state <= next_state;
end

assign g[0] = (state == 2'b01); // Set g0 when in state B
assign g[1] = (state == 2'b10); // Set g1 when in state C
assign g[2] = 1'b0; // g2 is always 0, as per the problem description

endmodule