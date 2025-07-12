module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    reg [3:0] shift_out;
    reg [3:0] count_out;

    always @(*) begin
        if (shift_ena)
            shift_out = {q[2:0], data};  // Shift left, data into LSB (MSB first)
        else
            shift_out = q;
    end

    always @(*) begin
        if (count_ena && !shift_ena)
            count_out = q - 1;
        else
            count_out = q;
    end

    always @(posedge clk) begin
        if (shift_ena)
            q <= shift_out;
        else if (count_ena)
            q <= count_out;
        else
            q <= q;
    end

endmodule