module TopModule(
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @(*) begin
        if (shift_ena)
            next_q = {data, q[3:1]};    // Shift right, data into MSB (most-significant-bit first)
        else if (count_ena)
            next_q = q - 1;             // Decrement by 1 modulo 16
        else
            next_q = q;                 // Hold current value
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule