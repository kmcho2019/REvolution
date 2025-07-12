module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (~a && b && ~state) begin
        state <= 1'b1;
    end else if (a && b && state) begin
        state <= 1'b0;
    end
end

always @(*) begin
    if (state && b) begin
        q = 1'b1;
    end else if (~state && a && ~b) begin
        q = 1'b1;
    end else begin
        q = 1'b0;
    end
end

endmodule