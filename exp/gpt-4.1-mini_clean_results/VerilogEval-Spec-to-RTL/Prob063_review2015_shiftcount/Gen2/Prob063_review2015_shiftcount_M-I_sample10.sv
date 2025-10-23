module TopModule (
    input        clk,
    input        reset,     // Active-high synchronous reset
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else if (shift_ena) begin
        // Shift data into MSB, shift right by 1
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement q as a 4-bit binary number
        q <= q - 1;
    end
    // else hold q
end

endmodule