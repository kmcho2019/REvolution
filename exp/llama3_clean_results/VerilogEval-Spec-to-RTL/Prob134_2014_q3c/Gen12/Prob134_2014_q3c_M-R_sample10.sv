module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

// Combinational logic for next state using assign
assign next_state = (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
                    (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
                    (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
                    (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
                    (y == 3'b100) ? (x ? 3'b100 : 3'b011) :
                    3'b000;

// Output logic
assign z = (y == 3'b011 || y == 3'b100);

assign Y0 = next_state[0];

endmodule