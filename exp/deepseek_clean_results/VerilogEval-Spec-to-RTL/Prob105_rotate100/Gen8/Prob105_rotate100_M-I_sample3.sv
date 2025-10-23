module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_enable = |ena;  // Clock gating condition
reg [99:0] q_next;

always @(*) begin
    if (load) begin
        q_next = data;
    end else begin
        case (ena)
            2'b01: q_next = {q[0], q[99:1]};    // Right rotate
            2'b10: q_next = {q[98:0], q[99]};   // Left rotate
            default: q_next = q;                // No rotation
        endcase
    end
end

always @(posedge clk) begin
    if (load || rotate_enable) begin
        q <= q_next;
    end
    // Else q maintains its value (implicit)
end

endmodule