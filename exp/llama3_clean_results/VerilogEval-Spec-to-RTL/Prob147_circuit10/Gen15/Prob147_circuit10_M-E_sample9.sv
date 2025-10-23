module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (~a && b) begin
        state <= 1'b1;
    end else if (a && b && state) begin
        state <= 1'b0;
    end else begin
        state <= state;
    end
end

always @(*) begin
    if (state) begin
        q = 1'b1;
    end else if (a && ~b) begin
        q = 1'b1;
    end else begin
        q = 1'b0;
    end
end

endmodule