module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (shift_ena) begin
        // Shift data into most-significant bit and shift existing bits to the right
        next_q = {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement the value in the register
        next_q = q - 1;
    end else begin
        // Hold the current value when neither shift_ena nor count_ena is high
        next_q = q;
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule