module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    wire ena = shift_ena | count_ena;
    reg [3:0] next_q;

    always @* begin
        if (shift_ena)
            next_q = {q[2:0], data};    // Shift left, MSB-first input at LSB
        else if (count_ena)
            next_q = q + 4'b1111;       // Decrement q by 1 modulo 16
        else
            next_q = q;                 // Hold current value
    end

    always @(posedge clk) begin
        if (ena)
            q <= next_q;
    end

endmodule