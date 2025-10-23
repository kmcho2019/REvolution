module TopModule(
    input  clk,
    input  d,
    output q
);

reg [1:0] cnt;
reg data_ff1, data_ff2;
reg clock_rising, clock_falling;

always @(posedge clk) begin
    cnt <= cnt + 1;
    clock_rising <= 1'b1;
    clock_falling <= 1'b0;
end

always @(negedge clk) begin
    clock_rising <= 1'b0;
    clock_falling <= 1'b1;
end

always @(posedge clock_rising or posedge clock_falling) begin
    if (clock_rising) begin
        data_ff1 <= d;
    end else if (clock_falling) begin
        data_ff2 <= d;
    end
end

assign q = (cnt[0] == 1'b1) ? data_ff2 : data_ff1;

endmodule