module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] state;

always @(posedge clk) begin
    if (a) begin
        state <= 4; // Stay at 4 when a is high
    end else if (state < 6) begin
        state <= state + 1; // Increment state when a is low and state < 6
    end else begin
        state <= 0; // Wrap around to 0 when state reaches 6
    end
end

assign q = state;

initial state = 4;

endmodule