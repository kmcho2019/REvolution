module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

localparam OFF = 1'b0;
localparam ON = 1'b1;

reg current_state;
reg next_state;

always @(*) begin
    case(current_state)
        OFF: next_state = (j == 1'b1) ? ON : OFF;
        ON: next_state = (k == 1'b1) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

assign out = (current_state == ON) ? 1'b1 : 1'b0;

endmodule