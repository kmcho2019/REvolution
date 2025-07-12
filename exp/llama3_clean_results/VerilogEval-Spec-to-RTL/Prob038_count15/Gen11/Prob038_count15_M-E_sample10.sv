module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

reg [3:0] state;

always @(posedge clk)
    if (reset) begin
        state <= 4'd0;
    end else begin
        state <= state + 4'd1;
    end

assign q = state;

endmodule