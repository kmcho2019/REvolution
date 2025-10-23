module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // 3-bit counter: counts consecutive ones (0 to 6)
    // State represents the count of consecutive ones seen so far
    reg [2:0] count_ones, next_count_ones;

    // Next cycle output signals, registered for one-cycle pulse
    reg disc_next, flag_next, err_next;

    // Combinational logic for next count and output signals
    always @(*) begin
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;

        if (in == 1'b1) begin
            if (count_ones == 3'd6) begin
                // 7 or more consecutive ones detected -> error
                next_count_ones = 3'd7; // Saturate beyond 6
                err_next = 1'b1;
            end else if (count_ones < 3'd6) begin
                // Increment count of ones up to 6
                next_count_ones = count_ones + 3'd1;
            end else begin
                // count_ones > 6 (stuck in error)
                next_count_ones = 3'd7;
                err_next = 1'b1;
            end
        end else begin // in == 0
            // Check for special sequences:
            // If count_ones == 5, next zero means discard inserted zero bit
            if (count_ones == 3'd5)
                disc_next = 1'b1;
            // If count_ones == 6, next zero means flag detected
            else if (count_ones == 3'd6)
                flag_next = 1'b1;

            // Zero resets count of ones
            next_count_ones = 3'd0;
        end
    end

    // Sequential logic: update count and outputs synchronously
    always @(posedge clk) begin
        if (reset) begin
            count_ones <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            count_ones <= next_count_ones;
            disc  <= disc_next;
            flag  <= flag_next;
            err   <= err_next;
        end
    end

endmodule