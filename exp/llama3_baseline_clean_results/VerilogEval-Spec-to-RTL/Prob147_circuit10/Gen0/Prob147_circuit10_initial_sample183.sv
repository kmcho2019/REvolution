module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (b == 1) begin
        q <= ~state;
        if (a == 0 || state == 1) begin
            state <= 1;
        end else begin
            state <= 0;
        end
    end else begin
        q <= 0;
        state <= 0;
    end
end

endmodule