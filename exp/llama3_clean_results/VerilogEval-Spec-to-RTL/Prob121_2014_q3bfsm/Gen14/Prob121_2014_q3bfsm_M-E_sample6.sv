module StateTransitionMatrix(
    input [2:0] y,
    input x,
    output reg [2:0] next_y,
    output reg z
);

always @(*) begin
    case (y)
        3'b000: begin
            next_y = x ? 3'b001 : 3'b000;
            z = 1'b0;
        end
        3'b001: begin
            next_y = x ? 3'b100 : 3'b001;
            z = 1'b0;
        end
        3'b010: begin
            next_y = x ? 3'b001 : 3'b010;
            z = 1'b0;
        end
        3'b011: begin
            next_y = x ? 3'b010 : 3'b001;
            z = 1'b1;
        end
        3'b100: begin
            next_y = x ? 3'b100 : 3'b011;
            z = 1'b1;
        end
        default: begin
            next_y = 3'b000;
            z = 1'b0;
        end
    endcase
end

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

StateTransitionMatrix state_transition_matrix(
    .y(y),
    .x(x),
    .next_y(next_y),
    .z(z)
);

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        y <= next_y;
    end
end

endmodule