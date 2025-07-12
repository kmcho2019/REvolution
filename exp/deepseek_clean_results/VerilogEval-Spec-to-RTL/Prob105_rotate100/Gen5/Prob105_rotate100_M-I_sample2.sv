module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

reg [99:0] q_next;
wire rotate_en = |ena;  // Rotation enable signal

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else if (rotate_en) begin
        q <= q_next;
    end
    // else: implicit clock gating (q retains value)
end

// Rotation logic (combinational)
always @(*) begin
    case (ena)
        2'b01: q_next = {q[0], q[99:1]};  // Right rotate
        2'b10: q_next = {q[98:0], q[99]};  // Left rotate
        default: q_next = q;               // No rotation
    endcase
end

endmodule