module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Clock gating for power optimization
wire clk_en = load | (ena != 2'b00) | (ena != 2'b11);
wire gated_clk = clk & clk_en;

// Rotation control signals
wire rotate_left = (ena == 2'b10);
wire rotate_right = (ena == 2'b01);

// Efficient rotation implementation using shared logic
wire [99:0] rotated_value;
assign rotated_value = rotate_left ? {q[98:0], q[99]} : 
                       rotate_right ? {q[0], q[99:1]} : q;

// Pipelined next state logic
reg [99:0] next_q_stage1;
always @(*) begin
    if (load) begin
        next_q_stage1 = data;
    end else begin
        next_q_stage1 = rotated_value;
    end
end

// Main register with gated clock
always @(posedge gated_clk) begin
    q <= next_q_stage1;
end

endmodule