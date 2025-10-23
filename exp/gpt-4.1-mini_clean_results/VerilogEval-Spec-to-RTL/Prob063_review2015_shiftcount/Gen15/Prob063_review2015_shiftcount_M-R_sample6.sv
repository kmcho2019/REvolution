module TopModule(
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @(*) begin
        if (shift_ena)
            next_q = {q[2:0], data};  // shift left with new data in LSB
        else if (count_ena)
            next_q = q - 1;           // decrement by 1 modulo 16
        else
            next_q = q;               // hold current value
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule