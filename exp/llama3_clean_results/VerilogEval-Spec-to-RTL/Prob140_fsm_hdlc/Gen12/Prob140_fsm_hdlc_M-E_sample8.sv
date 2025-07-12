module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] counter_ones; // Counter for consecutive ones
reg [2:0] counter_total; // Counter for total bits since last flag or reset
reg flag_error; // Flag for error condition (7 or more consecutive ones)

always @(posedge clk) begin
    if (reset) begin
        counter_ones <= 0;
        counter_total <= 0;
        flag_error <= 0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        disc <= 0;
        flag <= 0;
        err <= 0;

        if (in) begin
            counter_ones <= counter_ones + 1;
            counter_total <= counter_total + 1;

            if (counter_ones == 5) begin
                disc <= 1; // Signal to discard the next bit
            end else if (counter_ones == 6 && counter_total == 7) begin
                flag <= 1; // Signal flag condition
            end

            if (counter_ones >= 7) begin
                flag_error <= 1; // Set error flag
            end
        end else begin
            counter_ones <= 0; // Reset counter on zero detection
            if (flag_error) begin
                err <= 1; // Assert error signal if flag_error is set
            end
            flag_error <= 0; // Reset error flag
        end

        if (disc) begin
            counter_total <= 0; // Reset total counter on discard
        end
    end
end

endmodule