module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;

always @(posedge clk) begin
    case ({current_state, x})
        3'b000_0, 3'b001_0, 3'b010_0, 3'b011_0: current_state <= 3'b000;
        3'b000_1: current_state <= 3'b001;
        3'b001_0: current_state <= 3'b001;
        3'b001_1: current_state <= 3'b100;
        3'b010_0: current_state <= 3'b010;
        3'b010_1: current_state <= 3'b001;
        3'b011_0: current_state <= 3'b001;
        3'b011_1: current_state <= 3'b010;
        3'b100_0: current_state <= 3'b011;
        3'b100_1: current_state <= 3'b100;
        default: current_state <= 3'b000; // default state
    endcase
end

always @(*) begin
    case (current_state)
        3'b000, 3'b001, 3'b010: z = 0;
        3'b011, 3'b100: z = 1;
        default: z = 0; // default output
    endcase
    Y0 = (x == 0) ? current_state[0] : (current_state == 3'b000) ? 1'b0 : 
                                             (current_state == 3'b001) ? 1'b1 : 
                                             (current_state == 3'b010) ? 1'b0 : 
                                             (current_state == 3'b011) ? 1'b0 : 
                                             (current_state == 3'b100) ? 1'b1 : 1'b0;
end

endmodule