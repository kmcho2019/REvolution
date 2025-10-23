module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] next_state;

always @(y or x) begin
    case (y)
        3'b000: begin
            if (~x) next_state = 3'b000;
            else next_state = 3'b001;
            z = 0;
        end
        3'b001: begin
            if (~x) next_state = 3'b001;
            else next_state = 3'b100;
            z = 0;
        end
        3'b010: begin
            if (~x) next_state = 3'b010;
            else next_state = 3'b001;
            z = 0;
        end
        3'b011: begin
            if (~x) next_state = 3'b001;
            else next_state = 3'b010;
            z = 1;
        end
        3'b100: begin
            if (~x) next_state = 3'b011;
            else next_state = 3'b100;
            z = 1;
        end
        default: begin
            next_state = 3'b000;
            z = 0;
        end
    endcase
    Y0 = next_state[0];
end

endmodule