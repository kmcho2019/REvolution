module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire [99:0] next_q;

always @(*) begin
    if (load) begin
        next_q = data;  // Load has highest priority
    end else begin
        case (ena)
            2'b01: next_q = {q[0], q[99:1]};  // Right rotate
            2'b10: next_q = {q[98:0], q[99]};  // Left rotate
            default: next_q = q;               // Hold value
        endcase
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule