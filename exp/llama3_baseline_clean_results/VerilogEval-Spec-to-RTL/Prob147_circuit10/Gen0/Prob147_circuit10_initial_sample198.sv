module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (~a && b) begin
        state <= 1;
    end else if (state && b) begin
        state <= 1;
    end else begin
        state <= 0;
    end
end

always @(posedge clk) begin
    if (b && ~state) begin
        q <= 1;
    end else if (a && ~b && state) begin
        q <= 1;
    end else begin
        q <= 0;
    end
end

endmodule