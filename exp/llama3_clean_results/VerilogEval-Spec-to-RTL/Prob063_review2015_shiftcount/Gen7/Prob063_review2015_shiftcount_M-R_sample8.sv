module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] counter;

initial begin
    counter = 4'b0000;
end

always @(posedge clk) begin
    if (shift_ena) begin
        counter <= {data, counter[3:1]};
    end else if (count_ena) begin
        counter <= counter - 1;
    end
end

assign q = counter;

endmodule