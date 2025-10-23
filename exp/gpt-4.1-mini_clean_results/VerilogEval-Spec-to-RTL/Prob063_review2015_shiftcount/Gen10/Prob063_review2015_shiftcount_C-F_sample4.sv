module TopModule(
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    // Synchronous reset to 0 for safe initialization (optional, can remove if not required)
    // If asynchronous or external reset is desired, modify accordingly.
    initial q = 4'b0000;

    always @(posedge clk) begin
        // Handle mutually exclusive operations explicitly
        if (shift_ena && !count_ena)
            q <= {q[2:0], data};          // Shift left and insert new MSB data at LSB
        else if (count_ena && !shift_ena)
            q <= q - 1;                  // Decrement q by 1
        else
            q <= q;                     // Hold current value if no enable or both enables asserted
    end

endmodule