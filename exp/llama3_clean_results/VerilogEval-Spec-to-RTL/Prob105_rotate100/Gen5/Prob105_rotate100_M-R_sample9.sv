module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

// Register to store the current state of the rotator
reg [99:0] q_reg;

// Signals to control the rotation direction
wire rotate_right;
wire rotate_left;

// Assign the rotation control signals
assign rotate_right = ena == 2'b01;
assign rotate_left = ena == 2'b10;

// Always block to load the data
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end
end

// Always block to handle the rotation
always @(posedge clk) begin
    if (!load) begin
        if (rotate_right) begin
            q_reg <= {q_reg[0], q_reg[99:1]};
        end else if (rotate_left) begin
            q_reg <= {q_reg[98:0], q_reg[99]};
        end
    end
end

// Assign the output of the rotator to q
assign q = q_reg;

endmodule