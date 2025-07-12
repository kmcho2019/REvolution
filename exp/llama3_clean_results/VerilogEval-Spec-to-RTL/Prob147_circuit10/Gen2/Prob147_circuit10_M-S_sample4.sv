module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

initial begin
    state = 1'b0;
end

always @(posedge clk) begin
    if (a == 1'b0 && b == 1'b1) begin
        state <= 1'b1;
    end else if (a == 1'b1 && b == 1'b1) begin
        state <= 1'b0;
    end else begin
        state <= state;
    end

    if ((a == 1'b1 && b == 1'b0) || (state == 1'b1 && b == 1'b1)) begin
        q <= 1'b1;
    end else begin
        q <= 1'b0;
    end
end

endmodule