module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a == 1 && b == 0) begin
        state <= 0;
    end else if (a == 0 && b == 1) begin
        state <= 1;
    end else if (a == 1 && b == 1) begin
        state <= ~state;
    end
end

always @(*) begin
    if (state == 0 && b == 1) begin
        q = 1;
    end else if (state == 1 && a == 1) begin
        q = 1;
    end else begin
        q = 0;
    end
end

endmodule