module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Generate rotation control signals
wire rotate_left = ena == 2'b10;
wire rotate_right = ena == 2'b01;

// Perform rotation
wire [99:0] rotated_left = {q_reg[98:0], q_reg[99]};
wire [99:0] rotated_right = {q_reg[0], q_reg[99:1]};

// Select between original data, rotated left, and rotated right
wire [99:0] next_q = load ? data : (rotate_left ? rotated_left : (rotate_right ? rotated_right : q_reg));

// Update q_reg on clock edge
always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule