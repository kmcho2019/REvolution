module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

reg [99:0] q_reg;

// Pre-calculate the rotated values
reg [99:0] rotate_right;
reg [99:0] rotate_left;

// Calculate the rotated values
assign rotate_right = {q_reg[0], q_reg[99:1]}; // Rotate right by one bit
assign rotate_left = {q_reg[98:0], q_reg[99]}; // Rotate left by one bit

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena == 2'b01) begin // Rotate right
        q_reg <= rotate_right;
    end else if (ena == 2'b10) begin // Rotate left
        q_reg <= rotate_left;
    end
end

assign q = q_reg;

endmodule