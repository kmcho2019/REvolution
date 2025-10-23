module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state (Gray encoded)
reg [2:0] next_y; // next state (Gray encoded)

always @(*) begin
    case (y)
        3'b000: begin // state 0
            if (~x) next_y = 3'b000; // stay in state 0
            else next_y = 3'b001; // transition to state 1
            z = 1'b0;
        end
        3'b001: begin // state 1
            if (~x) next_y = 3'b001; // stay in state 1
            else next_y = 3'b110; // transition to state 4
            z = 1'b0;
        end
        3'b010: begin // state 2
            if (~x) next_y = 3'b010; // stay in state 2
            else next_y = 3'b001; // transition to state 1
            z = 1'b0;
        end
        3'b011: begin // state 3
            if (~x) next_y = 3'b001; // transition to state 1
            else next_y = 3'b010; // transition to state 2
            z = 1'b1;
        end
        3'b100: begin // state 4
            if (~x) next_y = 3'b011; // transition to state 3
            else next_y = 3'b100; // stay in state 4
            z = 1'b1;
        end
        default: begin
            next_y = 3'b000; // default to state 0
            z = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else if (y!== next_y) begin // only update state if it changes
        y <= next_y;
    end
end

endmodule