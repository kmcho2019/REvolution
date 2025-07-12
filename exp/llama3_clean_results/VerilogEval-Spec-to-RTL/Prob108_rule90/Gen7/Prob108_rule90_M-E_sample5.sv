module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [511:0] left_neighbors;
        reg [511:0] right_neighbors;
        reg [511:0] next_state;

        // Calculate left neighbors
        left_neighbors[0] = 1'b0; // Boundary condition
        left_neighbors[511:1] = q_reg[510:0];

        // Calculate right neighbors
        right_neighbors[511] = 1'b0; // Boundary condition
        right_neighbors[510:0] = q_reg[511:1];

        // Calculate next state using XOR of left and right neighbors
        next_state = left_neighbors ^ right_neighbors;

        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule