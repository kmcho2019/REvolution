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
        counter <= {data, counter[2:0]};
    end
end

always @(posedge clk) begin
    if (count_ena) begin
        if (counter == 4'b0000) begin
            counter <= 4'b1111; // Wrap around to maximum value
        end else begin
            counter <= counter - 1;
        end
    end
end

assign q = counter;

endmodule