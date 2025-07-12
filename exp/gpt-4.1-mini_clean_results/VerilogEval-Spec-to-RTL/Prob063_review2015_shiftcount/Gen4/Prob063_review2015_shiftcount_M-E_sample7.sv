module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (count_ena) begin
        // Decrement q by 1 when count_ena asserted
        next_q = q - 4'd1;
    end else if (shift_ena) begin
        // Shift in data at MSB, shift right by one bit
        next_q = {data, q[3:1]};
    end else begin
        // Hold current value
        next_q = q;
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule