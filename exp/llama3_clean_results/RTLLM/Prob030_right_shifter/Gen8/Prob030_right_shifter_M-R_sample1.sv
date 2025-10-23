module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

    // Initialize q to 0
    initial q = 8'd0;

    // Right shift q by 1 bit and insert d into the most significant position on each rising edge of the clock
    always @(posedge clk) begin
        q <= {d, q[7:1]};
    end

    // Alternatively, if we wanted to use assign for a part of the logic, we could define an internal signal
    // However, in this case, it's not necessary as the logic is straightforward and already handled within the always block

endmodule