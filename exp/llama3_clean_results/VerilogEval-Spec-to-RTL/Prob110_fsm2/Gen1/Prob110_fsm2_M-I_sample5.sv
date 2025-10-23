module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // Two states: OFF and ON
parameter OFF = 2'b00, ON = 2'b01;
reg [1:0] nextState;

always @(*) begin
    case(state)
        OFF: if (j) nextState = ON;
             else nextState = OFF;
        ON:  if (k) nextState = OFF;
             else nextState = ON;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
        out <= 1'b0;
    end
    else begin
        state <= nextState;
        case(state)
            OFF: out <= 1'b0;
            ON:  out <= 1'b1;
        endcase
    end
end

endmodule