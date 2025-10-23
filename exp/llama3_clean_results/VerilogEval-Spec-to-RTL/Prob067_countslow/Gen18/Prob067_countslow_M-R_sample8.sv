module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] state;
reg [3:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000;
    end else if (slowena) begin
        next_state = (state == 4'b1001) ? 4'b0000 : state + 1'b1;
        state <= next_state;
    end else begin
        state <= state;
    end
end

assign q = state;

endmodule