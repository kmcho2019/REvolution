module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

reg [99:0] q_reg;

// Rotation logic
wire [99:0] rotate_right = {q_reg[0], q_reg[99:1]};
wire [99:0] rotate_left = {q_reg[98:0], q_reg[99]};

// Next state logic
wire [99:0] next_q = (ena == 2'b01) ? rotate_right :
                     (ena == 2'b10) ? rotate_left : q_reg;

// Sequential logic
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_q;
    end
end

assign q = q_reg;

endmodule