module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Use a reset signal for initialization
reg reset;
always @ (posedge clk) begin
    if (reset) begin
        current_state <= 3'b000;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state and output z
assign z = (y == 3'b011 || y == 3'b100);
assign next_state = (y == 3'b000 && !x) ? 3'b000 :
                   (y == 3'b000 && x)  ? 3'b001 :
                   (y == 3'b001 && !x) ? 3'b001 :
                   (y == 3'b001 && x)  ? 3'b100 :
                   (y == 3'b010 && !x) ? 3'b010 :
                   (y == 3'b010 && x)  ? 3'b001 :
                   (y == 3'b011 && !x) ? 3'b001 :
                   (y == 3'b011 && x)  ? 3'b010 :
                   (y == 3'b100 && !x) ? 3'b011 :
                   (y == 3'b100 && x)  ? 3'b100 : 3'b000;

// Directly assign output Y0 from next_state
assign Y0 = next_state[0];

endmodule