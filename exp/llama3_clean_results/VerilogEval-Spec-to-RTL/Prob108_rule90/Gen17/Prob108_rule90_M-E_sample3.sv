module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Bitwise shift operations to align left and right neighbors
wire [511:0] left_neighbors;
wire [511:0] right_neighbors;

assign left_neighbors = {1'b0, q_reg[511:1]};
assign right_neighbors = {q_reg[510:0], 1'b0};

// Bitwise XOR operations to calculate next state
wire [511:0] next_state;
assign next_state = left_neighbors ^ right_neighbors;

// Sequential logic to update q_reg on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule