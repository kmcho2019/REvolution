module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // 3-bit counter: counts consecutive ones (0 to 6)
    reg [2:0] count_ones, next_count_ones;

    // Internal error latch, set once when error occurs, cleared on zero input or reset
    reg error_latched, next_error_latched;

    // Next cycle output signals
    reg disc_next, flag_next;

    // Combinational logic for next count and outputs
    always @(*) begin
        disc_next = 1'b0;
        flag_next = 1'b0;
        next_error_latched = error_latched;

        if (in) begin
            if (count_ones == 3'd6) begin
                // Error condition detected: 7 consecutive ones
                next_error_latched = 1'b1;
                // Saturate counter at 6 (max)
                next_count_ones = 3'd6;
            end else begin
                // Increment count of ones
                next_count_ones = count_ones + 3'd1;
            end
        end else begin
            // Input zero resets count and clears error latch
            next_count_ones = 3'd0;
            next_error_latched = 1'b0;

            // Output signals for disc and flag pulses on next cycle
            if (count_ones == 3'd5)
                disc_next = 1'b1;
            else if (count_ones == 3'd6)
                flag_next = 1'b1;
        end
    end

    // Sequential logic: update registers synchronously
    always @(posedge clk) begin
        if (reset) begin
            count_ones   <= 3'd0;
            error_latched <= 1'b0;
            disc         <= 1'b0;
            flag         <= 1'b0;
            err          <= 1'b0;
        end else begin
            count_ones   <= next_count_ones;
            error_latched <= next_error_latched;
            disc         <= disc_next;
            flag         <= flag_next;
            // err asserted while error latched
            err          <= error_latched;
        end
    end

endmodule