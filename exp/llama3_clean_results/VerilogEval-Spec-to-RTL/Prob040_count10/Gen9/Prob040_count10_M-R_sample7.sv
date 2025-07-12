module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;
reg [3:0] next_state;

always @(*) begin
    if (reset) begin
        next_state = 4'd0;
    end else if (state == 4'd9) begin
        next_state = 4'd0;
    end else begin
        next_state = state + 1;
    end
end

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

endmodule