module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 10'd0;
    end else begin
        if (state == 10'd999) begin
            state <= 10'd0;
        end else begin
            state <= state + 10'd1;
        end
    end
end

assign q = state;

endmodule