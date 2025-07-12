module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (b == 1) begin
        q <= ~state;
    end else begin
        q <= a;
    end

    if (a == 1 && b == 1) begin
        state <= ~state;
    end else if (a == 0 && b == 1) begin
        state <= ~state;
    end else begin
        state <= state;
    end
end

endmodule