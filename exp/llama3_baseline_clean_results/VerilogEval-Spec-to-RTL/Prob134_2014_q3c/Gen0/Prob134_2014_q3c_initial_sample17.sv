module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] state, next_state;

always @(posedge clk)
    state <= next_state;

always @(*)
begin
    case (state)
        3'b000: 
            next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            z = 1'b0;
        3'b001: 
            next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            z = 1'b0;
        3'b010: 
            next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            z = 1'b0;
        3'b011: 
            next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            z = 1'b1;
        3'b100: 
            next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            z = 1'b1;
        default: 
            next_state = 3'b000; // default to state 000
            z = 1'b0;
    endcase

    Y0 = (next_state == 3'b000 || next_state == 3'b001 || next_state == 3'b010 || next_state == 3'b011 || next_state == 3'b100) ? next_state[0] : 1'b0;
end

endmodule