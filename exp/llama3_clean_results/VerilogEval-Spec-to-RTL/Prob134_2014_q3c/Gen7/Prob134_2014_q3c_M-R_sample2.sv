module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
initial current_state = 3'b000;

always @ (posedge clk) begin
    case (current_state)
        3'b000: current_state <= x ? 3'b001 : 3'b000;
        3'b001: current_state <= x ? 3'b100 : 3'b001;
        3'b010: current_state <= x ? 3'b001 : 3'b010;
        3'b011: current_state <= x ? 3'b010 : 3'b001;
        3'b100: current_state <= x ? 3'b100 : 3'b011;
        default: current_state <= 3'b000;
    endcase
end

assign Y0 = (x == 1'b0) ? current_state[0] : 
            (current_state == 3'b000 || current_state == 3'b001 || current_state == 3'b010) ? 1'b1 : 
            (current_state == 3'b011) ? 1'b0 : 
            (current_state == 3'b100) ? 1'b0 : 1'b0;

assign z = (current_state == 3'b011 || current_state == 3'b100);

endmodule