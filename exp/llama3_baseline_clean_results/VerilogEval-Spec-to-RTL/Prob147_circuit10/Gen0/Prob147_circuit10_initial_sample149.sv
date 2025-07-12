module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a == 1 && b == 1) begin
        state <= 0;
        q <= 0;
    end else if (a == 0) begin
        q <= b;
        if (b == 1) begin
            state <= 0;
        end else begin
            state <= state;
        end
    end else begin
        if (b == 0) begin
            q <= 1;
            state <= state;
        end else begin
            q <= 0;
            state <= 1;
        end
    end
end

endmodule