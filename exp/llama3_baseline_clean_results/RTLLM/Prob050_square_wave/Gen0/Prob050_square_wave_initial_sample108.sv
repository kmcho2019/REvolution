module square_wave(
    input           clk,      // Clock signal
    input   [7:0]   freq,     // Frequency control
    output  reg     wave_out  // Square wave output signal
    );

    reg [7:0] count;  // Counter register

    // Initialize wave_out and count to 0
    initial begin
        wave_out = 1'b0;
        count = 8'd0;
    end

    // Always block to handle the counter operation and square wave generation
    always @(posedge clk) begin
        // Increment the counter on each rising edge of the clk signal
        if (count < (freq - 1)) begin
            count <= count + 1'b1;
        end
        // When count reaches freq, reset it to 0 and toggle wave_out
        else begin
            count <= 8'd0;
            wave_out <= ~wave_out;  // Toggle wave_out
        end
    end

endmodule