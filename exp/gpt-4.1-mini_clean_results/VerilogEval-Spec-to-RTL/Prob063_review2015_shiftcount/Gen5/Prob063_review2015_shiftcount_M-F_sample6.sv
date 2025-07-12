module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Initialize q to zero at simulation start to avoid unknown states
    // This helps simulation tools start q at a known value,
    // but synthesis tools may ignore this block.
    initial begin
        q = 4'b0000;
    end

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift right by 1 bit: shift bits from MSB towards LSB
            // Insert new data bit into MSB q[3]
            // q[3] <= data
            // q[2] <= previous q[3]
            // q[1] <= previous q[2]
            // q[0] <= previous q[1]
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement the 4-bit register, wrapping naturally from 0 to 15
            q <= q - 4'd1;
        end
        // If neither enable is asserted, retain previous q
    end

endmodule