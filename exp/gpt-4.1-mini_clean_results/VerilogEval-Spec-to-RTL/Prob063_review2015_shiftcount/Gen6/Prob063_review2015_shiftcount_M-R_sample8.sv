module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

reg [3:0] q_next;

always @(*) begin
    if (shift_ena) begin
        // Shift left, input data at LSB (MSB first means shifting bits toward MSB)
        q_next = {q[2:0], data};
    end else if (count_ena) begin
        // Decrement q by 1
        q_next = q - 1;
    end else begin
        // Hold current value
        q_next = q;
    end
end

always @(posedge clk) begin
    q <= q_next;
end

endmodule