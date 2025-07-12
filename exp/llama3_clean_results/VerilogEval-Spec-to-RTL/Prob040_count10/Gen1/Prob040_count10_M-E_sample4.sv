module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] state;

always @ (posedge clk) begin
    if (reset) begin
        state <= 4'b0000;
    end else if (state == 4'd9) begin
        state <= 4'b0000;
    end else begin
        state <= state + 1'b1;
    end
end

assign q = state;

endmodule