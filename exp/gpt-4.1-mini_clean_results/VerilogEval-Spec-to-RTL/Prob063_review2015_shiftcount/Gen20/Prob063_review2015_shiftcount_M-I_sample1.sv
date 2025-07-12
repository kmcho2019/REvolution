module TopModule(
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    // Synchronous reset via initial block removed (assume FPGA or external reset)
    // Initialize on first clock with shift_ena=0, count_ena=0 scenario or external reset
    
    // Shift operation: shift left, MSB first, data into LSB
    always @(posedge clk) begin
        if (shift_ena) begin
            q <= {q[2:0], data};
        end
    end

    // Count operation: decrement q when count_ena is high
    always @(posedge clk) begin
        if (!shift_ena && count_ena) begin
            q <= q - 4'd1;  // subtract 1 mod 16
        end
    end

    // When neither shift_ena nor count_ena is high, q holds its value naturally
endmodule