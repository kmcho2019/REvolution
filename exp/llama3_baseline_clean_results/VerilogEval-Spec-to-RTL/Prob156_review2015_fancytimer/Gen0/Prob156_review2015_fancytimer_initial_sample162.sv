module TopModule(
    input        clk,
    input        reset,
    input        data,
    output [3:0] count,
    output       counting,
    output       done,
    input        ack
);

reg [3:0] delay;
reg [3:0] current_count;
reg [9:0] counter;
reg [3:0] shift_register;
reg        counting_reg;
reg        done_reg;
reg [1:0] pattern_detector;

always @ (posedge clk) begin
    if (reset) begin
        // Reset all registers and counters
        delay <= 0;
        current_count <= 0;
        counter <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        pattern_detector <= 0;
        shift_register <= 0;
    end else begin
        case (pattern_detector)
            2'b00: begin
                // Search for the pattern 1101
                if (data) begin
                    pattern_detector <= pattern_detector + 1;
                end else begin
                    pattern_detector <= 0;
                end
            end
            2'b01: begin
                // Second bit of the pattern
                if (data) begin
                    pattern_detector <= pattern_detector + 1;
                end else begin
                    pattern_detector <= 0;
                end
            end
            2'b10: begin
                // Third bit of the pattern
                if (~data) begin
                    pattern_detector <= pattern_detector + 1;
                end else begin
                    pattern_detector <= 0;
                end
            end
            2'b11: begin
                // Fourth bit of the pattern
                if (data) begin
                    // Start shifting in the delay
                    pattern_detector <= 0;
                    shift_register <= 0;
                end else begin
                    pattern_detector <= 0;
                end
            end
        endcase

        if (pattern_detector == 0 && shift_register != 0) begin
            // Shift in the delay
            shift_register <= {data, shift_register[3:1]};
            if (&shift_register[3:1] == 1'b1) begin
                // Finish shifting in the delay
                delay <= shift_register;
                counter <= 0;
                current_count <= delay + 1;
                counting_reg <= 1;
            end
        end

        if (counting_reg) begin
            // Count for the specified delay
            counter <= counter + 1;
            if (counter == 1000) begin
                counter <= 0;
                current_count <= current_count - 1;
                if (current_count == 0) begin
                    counting_reg <= 0;
                    done_reg <= 1;
                end
            end
        end

        if (done_reg && ack) begin
            // Reset the state machine
            done_reg <= 0;
            pattern_detector <= 0;
        end
    end
end

assign count = (counting_reg) ? {4{current_count != 0}} : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule