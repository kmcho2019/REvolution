module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift data into MSB, shift right by 1
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement q as a 4-bit down counter with wrap-around
            q <= q - 1'b1;
        end
        // else retain q
    end

endmodule