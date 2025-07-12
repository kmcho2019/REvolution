module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg current_state;
assign out = ~current_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= 0;
    end else begin
        current_state <= (current_state && in) || (~current_state && ~in);
    end
end

endmodule