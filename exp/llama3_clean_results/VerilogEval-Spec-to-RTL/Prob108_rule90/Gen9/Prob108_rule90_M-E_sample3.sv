module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

// Define a module for a single cell
module Cell(
    input  left,
    input  center,
    input  right,
    output next_state
);
    assign next_state = left ^ center ^ right;
endmodule

// Create an array of cells
wire [511:0] next_state;
reg [511:0] q_reg;

// Assign the next state for the leftmost cell
Cell leftmost_cell(.left(1'b0),.center(q_reg[0]),.right(q_reg[1]),.next_state(next_state[0]));

// Assign the next state for the inner cells
generate
    for (genvar i = 1; i < 511; i++) begin
        Cell inner_cell(.left(q_reg[i-1]),.center(q_reg[i]),.right(q_reg[i+1]),.next_state(next_state[i]));
    end
endgenerate

// Assign the next state for the rightmost cell
Cell rightmost_cell(.left(q_reg[510]),.center(q_reg[511]),.right(1'b0),.next_state(next_state[511]));

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule