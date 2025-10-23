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
        // Shift right by one bit: data enters at MSB (bit 3)
        // Existing bits q[3:1] shift down to q[2:0]
        // q[0] is dropped (lost) during the shift, as expected for a shift register
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