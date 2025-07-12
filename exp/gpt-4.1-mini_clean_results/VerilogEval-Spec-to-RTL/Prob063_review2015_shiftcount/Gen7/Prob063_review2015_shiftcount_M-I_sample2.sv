module TopModule (
    input        clk,
    input        rst,        // Active-high synchronous reset
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

// On reset, initialize shift register to zero
// On count_ena, decrement q by 1 with wrap-around
// On shift_ena, shift bits right, inserting data at MSB (bit 3)
// Both control inputs won't be high simultaneously; priority doesn't matter

always @(posedge clk) begin
    if (rst) begin
        q <= 4'b0000;
    end else if (count_ena) begin
        q <= q - 1;        // 4-bit down counter with wrap-around
    end else if (shift_ena) begin
        q <= {data, q[3:1]};  // Shift right: MSB <= data, other bits shift toward LSB
    end
    // else hold q
end

endmodule