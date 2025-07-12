module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000;
    end else if (slowena) begin
        if (state == 4'b1001) begin
            state <= 4'b0000;
        end else begin
            state <= state + 4'b0001;
        end
    end
end

assign q = state;

endmodule