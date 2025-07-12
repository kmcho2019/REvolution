module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg signed [5:0] counter; // 6 bits to handle range and direction

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 6'd0;
            wave <= 5'd0;
        end else begin
            // Determine direction based on counter boundaries
            // If counter at max (31), next step decrements
            // If counter at min (0), next step increments
            if (counter == 6'd31)
                counter <= counter - 6'd1;
            else if (counter == 6'd0)
                counter <= counter + 6'd1;
            else begin
                // Direction inferred from previous step:
                // If MSB of counter is 0 and increasing, increment
                // If MSB is 1 (negative signed), decrement
                if (counter[5] == 1'b0)
                    counter <= counter + 6'd1;
                else
                    counter <= counter - 6'd1;
            end

            wave <= counter[4:0];
        end
    end

endmodule