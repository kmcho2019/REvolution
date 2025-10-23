module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    // Load operation initializes the one-hot shift register pattern.
    // If load=1, set counter to one at position corresponding to data (simplified).
    // For counting down, shift right by 1 each cycle; when zero, stay zero.

    always @(posedge clk) begin
        if (load) begin
            // If data is zero, counter is zero (timer expired immediately)
            // Otherwise, create a one-hot pattern with a single '1' bit set at position data-1
            // Since data ranges 0-1023, but counter is 10 bits, clamp data to max 10
            if (data == 0)
                counter <= 10'b0;
            else if (data > 10)
                counter <= 10'b1000000000; // max count
            else
                counter <= 10'b1 << (data - 1);
        end else if (counter != 0) begin
            counter <= counter >> 1; // shift right to count down
        end
    end

    // Terminal count asserted when counter is zero
    assign tc = (counter == 0);

endmodule