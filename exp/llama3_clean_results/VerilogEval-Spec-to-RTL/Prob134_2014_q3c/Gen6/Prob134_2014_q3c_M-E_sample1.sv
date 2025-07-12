module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;

always @ (posedge clk) begin
    case ({x, current_state})
        4'b0_000: current_state <= 3'b000;
        4'b0_001: current_state <= 3'b001;
        4'b0_010: current_state <= 3'b010;
        4'b0_011: current_state <= 3'b001;
        4'b0_100: current_state <= 3'b011;
        4'b1_000: current_state <= 3'b001;
        4'b1_001: current_state <= 3'b100;
        4'b1_010: current_state <= 3'b001;
        4'b1_011: current_state <= 3'b010;
        4'b1_100: current_state <= 3'b100;
        default: current_state <= 3'b000;
    endcase
end

assign Y0 = current_state[0];

assign z = (current_state == 3'b011) || (current_state == 3'b100);

endmodule