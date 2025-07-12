module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
initial current_state = 3'b000; // Initialize current_state to avoid undefined behavior

always @ (posedge clk) begin
    case (current_state)
        3'b000: current_state <= x ? 3'b001 : 3'b000;
        3'b001: current_state <= x ? 3'b100 : 3'b001;
        3'b010: current_state <= x ? 3'b001 : 3'b010;
        3'b011: current_state <= x ? 3'b010 : 3'b001;
        3'b100: current_state <= x ? 3'b100 : 3'b011;
        default: current_state <= 3'b000; // Ensure current_state does not get stuck in an undefined state
    endcase
end

assign Y0 = current_state[0];

assign z = (current_state == 3'b011) || (current_state == 3'b100);

endmodule