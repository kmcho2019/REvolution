module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena)
            q <= {data, q[3:1]};   // Shift right, input data at MSB (MSB-first)
        else if (count_ena)
            q <= q - 1;
        // else retain current value
    end

endmodule