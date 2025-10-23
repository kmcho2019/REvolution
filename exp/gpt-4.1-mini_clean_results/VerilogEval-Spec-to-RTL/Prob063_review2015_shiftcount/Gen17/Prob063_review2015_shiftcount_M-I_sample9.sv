module TopModule(
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift right by 1 inserting data at MSB (MSB-first shifting)
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement q by 1 modulo 16
            q <= q - 4'd1;
        end
        // else hold current value
    end

endmodule