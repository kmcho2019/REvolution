module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] nextState;

always @(*) begin
    case(state)
        2'b00: begin // State A
            if (~r[0] && ~r[1] && ~r[2])
                nextState = 2'b00;
            else if (r[0])
                nextState = 2'b01; // State B
            else if (r[1])
                nextState = 2'b10; // State C
            else
                nextState = 2'b11; // State D
        end
        2'b01: begin // State B
            if (r[0])
                nextState = 2'b01;
            else
                nextState = 2'b00; // State A
        end
        2'b10: begin // State C
            if (r[1])
                nextState = 2'b10;
            else
                nextState = 2'b00; // State A
        end
        default: // State D (not actually needed, but reserved for completeness)
            if (~r[2])
                nextState = 2'b00; // State A
            else
                nextState = 2'b11; // State D
    endcase
end

always @(posedge clk) begin
    if (~resetn)
        state <= 2'b00;
    else
        state <= nextState;
end

assign g[0] = (state == 2'b01); // g0 is 1 in State B
assign g[1] = (state == 2'b10); // g1 is 1 in State C
assign g[2] = 0; // g2 is always 0, since device 2 is granted only when it is the only device requesting

endmodule