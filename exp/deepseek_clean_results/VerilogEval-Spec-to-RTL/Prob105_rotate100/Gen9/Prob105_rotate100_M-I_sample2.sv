module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

reg [99:0] next_q;
wire rotate_en = |ena;  // Enable rotation when ena is 01 or 10

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (rotate_en) begin
        q <= next_q;
    end
    // No else clause - q retains value when not loading or rotating
end

always @(*) begin
    case (ena)
        2'b01: next_q = {q[0], q[99:1]};  // Right rotate
        2'b10: next_q = {q[98:0], q[99]};  // Left rotate
        default: next_q = q;               // Default case (unused due to rotate_en)
    endcase
end

endmodule