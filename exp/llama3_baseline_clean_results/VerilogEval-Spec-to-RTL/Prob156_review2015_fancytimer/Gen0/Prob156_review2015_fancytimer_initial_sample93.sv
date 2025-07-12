module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] delay;
reg [3:0] remaining;
reg [11:0] counter;
reg [3:0] shift_counter;
reg [3:0] pattern_register;
reg pattern_detected;
reg shifting;
reg counting_enabled;
reg done_asserted;

always @(posedge clk) begin
    if (reset) begin
        pattern_detected <= 1'b0;
        shifting <= 1'b0;
        counting_enabled <= 1'b0;
        done_asserted <= 1'b0;
        count <= 4'b0;
        counting <= 1'b0;
        done <= 1'b0;
        pattern_register <= 4'b0;
        shift_counter <= 4'b0;
        delay <= 4'b0;
        remaining <= 4'b0;
        counter <= 12'b0;
    end else begin
        // Detect input pattern
        if (!pattern_detected) begin
            {pattern_register[2:0], pattern_register[3]} <= {pattern_register[2:0], data};
            if (pattern_register == 4'b1101) begin
                pattern_detected <= 1'b1;
            end
        end

        // Shift in delay value
        if (pattern_detected && !shifting) begin
            shifting <= 1'b1;
        end
        if (shifting) begin
            if (shift_counter < 4'b1000) begin
                {delay[2:0], delay[3]} <= {delay[2:0], data};
                shift_counter <= shift_counter + 1'b1;
            end else begin
                shifting <= 1'b0;
                counting_enabled <= 1'b1;
                remaining <= delay + 1'b1;
                counter <= 12'b0;
            end
        end

        // Count down timer
        if (counting_enabled) begin
            counting <= 1'b1;
            if (counter < 10'b10000000000) begin
                counter <= counter + 1'b1;
            end else begin
                counter <= 12'b0;
                remaining <= remaining - 1'b1;
                if (remaining == 4'b0) begin
                    counting_enabled <= 1'b0;
                    done_asserted <= 1'b1;
                end
            end
        end

        // Assert done and wait for ack
        if (done_asserted && !ack) begin
            done <= 1'b1;
        end else if (done_asserted && ack) begin
            done_asserted <= 1'b0;
            done <= 1'b0;
            pattern_detected <= 1'b0;
        end

        // Output current remaining time
        count <= remaining;
    end
end

endmodule