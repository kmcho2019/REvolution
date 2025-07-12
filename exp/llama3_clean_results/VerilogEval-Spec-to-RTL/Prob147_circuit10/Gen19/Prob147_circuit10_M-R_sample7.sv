module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (!a && b) begin
        state <= 1;
    end else if (a && b && state == 1) begin
        state <= 0;
    end else if (!a && !b && state == 1) begin
        state <= 1;
    end else if (a && !b && state == 1) begin
        state <= 1;
    end else if (!a && b && state == 0) begin
        state <= 1;
    end else begin
        state <= 0;
    end
end

always @(*) begin
    if (state == 1) begin
        q = 1;
    end else if (a && !b) begin
        q = 1;
    end else begin
        q = 0;
    end
end

endmodule