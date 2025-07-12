module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Clock enable signal
wire cen = load || (ena != 2'b00 && ena != 2'b11);

// Rotate right by one bit
wire [99:0] rot_right = {q_reg[0], q_reg[99:1]};

// Rotate left by one bit
wire [99:0] rot_left = {q_reg[98:0], q_reg[99]};

// Select the correct rotation direction
wire [99:0] next_q = (ena == 2'b01) ? rot_right :
                      (ena == 2'b10) ? rot_left :
                      q_reg;

// Update q_reg on the next clock edge
always @(posedge clk) begin
    if (cen) begin
        if (load) begin
            q_reg <= data;
        end else begin
            q_reg <= next_q;
        end
    end
end

assign q = q_reg;

endmodule