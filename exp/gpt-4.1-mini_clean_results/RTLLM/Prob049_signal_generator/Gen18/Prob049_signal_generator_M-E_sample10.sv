module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // 6-bit counter to cycle through 0 to 62 (63 counts)
    reg [5:0] counter;

    // On reset, counter is cleared
    // On each clock, counter increments, wraps to 0 at 62
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 6'd0;
        end else begin
            if (counter == 6'd62)
                counter <= 6'd0;
            else
                counter <= counter + 6'd1;
        end
    end

    // Combinational logic: generate wave output based on counter
    // For counts 0 to 31: wave = counter (increment)
    // For counts 32 to 62: wave = 62 - counter (decrement)
    always @(*) begin
        if (counter <= 6'd31)
            wave = counter[4:0];
        else
            wave = (6'd62 - counter)[4:0];
    end

endmodule