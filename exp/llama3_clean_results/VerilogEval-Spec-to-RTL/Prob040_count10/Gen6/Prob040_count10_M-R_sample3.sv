module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] current_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= 4'd0;
    end else if (current_state == 4'd9) begin
        current_state <= 4'd0;
    end else begin
        current_state <= current_state + 4'd1;
    end
end

assign q = current_state;

endmodule