module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Initialize state
initial begin
    current_state = 3'b000;
end

// Combinational logic for next state
assign next_state = (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
                    (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
                    (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
                    (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
                    (y == 3'b100) ? (x ? 3'b100 : 3'b011) : 3'b000;

// Combinational logic for output z
assign z = (y == 3'b011 || y == 3'b100);

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

// Directly assign output Y0 from current state
assign Y0 = current_state[0];

endmodule