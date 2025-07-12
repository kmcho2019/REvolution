module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output reg Y0,
    output reg z
);

reg [2:0] current_state;

// Initialize state
initial begin
    current_state = 3'b000;
end

// Combined sequential and combinational logic
always @ (posedge clk) begin
    case (current_state)
        3'b000: current_state <= x? 3'b001 : 3'b000;
        3'b001: current_state <= x? 3'b100 : 3'b001;
        3'b010: current_state <= x? 3'b001 : 3'b010;
        3'b011: current_state <= x? 3'b010 : 3'b001;
        3'b100: current_state <= x? 3'b100 : 3'b011;
        default: current_state <= 3'b000;
    endcase
    z <= (current_state == 3'b011 || current_state == 3'b100);
    Y0 <= current_state[0];
end

endmodule