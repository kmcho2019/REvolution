module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_d;

always @(*) begin
    if (clk) begin
        q <= d;
        prev_d <= d;
    end else begin
        prev_d <= prev_d;
    end
end

// Optional initialization for simulation purposes
initial begin
    q = 0;
    prev_d = 0;
end

endmodule