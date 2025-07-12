module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_state; // next state

always @(*) begin
    case(y)
        3'b000: next_state = x ? 3'b001 : 3'b000;
        3'b001: next_state = x ? 3'b100 : 3'b001;
        3'b010: next_state = x ? 3'b001 : 3'b010;
        3'b011: next_state = x ? 3'b010 : 3'b001;
        3'b100: next_state = x ? 3'b100 : 3'b011;
        default: next_state = 3'b000; // default to state 000
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous reset
        z <= 0;
    end else begin
        y <= next_state; // update state
        case(y)
            3'b000, 3'b001, 3'b010: z <= 0;
            3'b011, 3'b100: z <= 1;
            default: z <= 0; // default output
        endcase
    end
end

endmodule