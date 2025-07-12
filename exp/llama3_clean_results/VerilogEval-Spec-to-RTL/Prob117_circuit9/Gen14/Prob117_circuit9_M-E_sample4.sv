module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] state;

initial begin
    state = 4;
    q = 4;
end

always @(posedge clk) begin
    if (a) begin
        state <= 4;
        q <= 4;
    end else begin
        if (state == 6) begin
            state <= 0;
            q <= 0;
        end else begin
            state <= state + 1;
            q <= state + 1;
        end
    end
end

endmodule