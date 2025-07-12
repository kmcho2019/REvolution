module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Initialize q to zero at simulation start for simulation stability
    // Note: This initial block does not synthesize to hardware reset!
    initial begin
        q = 4'b0000;
    end

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift register operation:
            // Shift bits right by 1 (towards LSB)
            // Insert new data bit at MSB (q[3])
            // Example: q = {data, q[3], q[2], q[1]};
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Down counter operation:
            // Decrement the 4-bit register value by 1 with wrap-around
            q <= q - 4'd1;
        end
        // If neither enable is asserted, q holds its value
    end

endmodule