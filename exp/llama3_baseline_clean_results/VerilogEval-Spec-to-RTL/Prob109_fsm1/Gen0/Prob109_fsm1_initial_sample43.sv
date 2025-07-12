module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg current_state;
reg next_state;

always @(*) begin
    case (current_state)
        1'b0: next_state = in ? 1'b0 : 1'b1;
        1'b1: next_state = in ? 1'b1 : 1'b0;
        default: next_state = 1'b1;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b1;
    end else begin
        current_state <= next_state;
    end
end

assign out = current_state;

endmodule