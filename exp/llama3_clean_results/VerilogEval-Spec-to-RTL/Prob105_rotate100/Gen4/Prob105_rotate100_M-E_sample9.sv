module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Barrel Shifter implementation
wire [99:0] rotated_left;
wire [99:0] rotated_right;

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        assign rotated_left[i] = (i == 0)? q_reg[99] : q_reg[i-1];
        assign rotated_right[i] = (i == 99)? q_reg[0] : q_reg[i+1];
    end
endgenerate

// Rotation control unit
wire rotate_left = ena == 2'b10;
wire rotate_right = ena == 2'b01;

// Select between original data, rotated left, and rotated right
wire [99:0] next_q = load? data : (rotate_left? rotated_left : (rotate_right? rotated_right : q_reg));

// Update q_reg on clock edge
always @(posedge clk) begin
    if (load || rotate_left || rotate_right) begin
        q_reg <= next_q;
    end
end

assign q = q_reg;

endmodule