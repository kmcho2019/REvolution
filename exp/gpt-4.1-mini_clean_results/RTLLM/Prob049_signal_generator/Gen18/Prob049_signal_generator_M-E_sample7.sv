module signal_generator (
    input           clk,
    input           rst_n,
    output  [4:0]   wave
);

    reg [5:0] counter; // [5]: direction (0=inc,1=dec), [4:0]: wave value

    // Output wave is lower 5 bits of counter
    assign wave = counter[4:0];

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 6'd0;  // wave=0, direction=0 (increment)
        end else begin
            if (counter[5] == 1'b0) begin
                // Increment mode
                if (counter[4:0] == 5'd31) begin
                    // Change direction to decrement
                    counter[5] <= 1'b1;
                    counter[4:0] <= 5'd30; // start decrementing from 30 next cycle
                end else begin
                    // Increment wave
                    counter[4:0] <= counter[4:0] + 1'b1;
                    counter[5] <= 1'b0;
                end
            end else begin
                // Decrement mode
                if (counter[4:0] == 5'd0) begin
                    // Change direction to increment
                    counter[5] <= 1'b0;
                    counter[4:0] <= 5'd1; // start incrementing from 1 next cycle
                end else begin
                    // Decrement wave
                    counter[4:0] <= counter[4:0] - 1'b1;
                    counter[5] <= 1'b1;
                end
            end
        end
    end

endmodule