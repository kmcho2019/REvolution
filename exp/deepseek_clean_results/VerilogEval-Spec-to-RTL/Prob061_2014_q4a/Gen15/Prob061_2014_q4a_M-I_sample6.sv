module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire enable = L || E;
wire next_Q;

always @(*) begin
    case ({L, E})
        2'b10: next_Q = R;    // Load has priority
        2'b01: next_Q = w;    // Shift enabled
        default: next_Q = Q;  // Hold state
    endcase
end

always @(posedge clk) begin
    if (enable) begin
        Q <= next_Q;
    end
end

endmodule