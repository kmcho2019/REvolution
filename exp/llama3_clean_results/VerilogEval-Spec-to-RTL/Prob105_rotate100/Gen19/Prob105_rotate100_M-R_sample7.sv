module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;
reg [99:0] next_state;

// Rotation Logic
wire [99:0] rotate_right = {q_reg[0], q_reg[99:1]};
wire [99:0] rotate_left = {q_reg[98:0], q_reg[99]};
wire [99:0] no_rotate = q_reg;

// Next State Logic
assign next_state = (load)? data : 
                    (ena == 2'b01)? rotate_right : 
                    (ena == 2'b10)? rotate_left : 
                    no_rotate;

// Output Logic
assign q = q_reg;

// Sequential Logic
always @(posedge clk) begin
    q_reg <= next_state;
end

endmodule