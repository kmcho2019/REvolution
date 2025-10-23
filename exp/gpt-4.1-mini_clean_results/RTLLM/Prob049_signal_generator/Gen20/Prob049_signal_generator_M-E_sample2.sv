module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg signed [5:0] count;    // Signed counter: range -32 to +31
    reg dir;                   // Direction: 0 = increment, 1 = decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count <= 6'sd0;
            dir   <= 1'b0;      // Start incrementing
            wave  <= 5'd0;
        end else begin
            // Update count based on direction
            if (dir == 1'b0)
                count <= count + 6'sd1;
            else
                count <= count - 6'sd1;

            // Change direction at boundaries
            if (count == 6'sd31)
                dir <= 1'b1;    // Switch to decrement
            else if (count == 6'sd0)
                dir <= 1'b0;    // Switch to increment

            // Output absolute value of count as 5-bit wave
            if (count < 0)
                wave <= -count[4:0];   // abs(count)
            else
                wave <= count[4:0];
        end
    end

endmodule