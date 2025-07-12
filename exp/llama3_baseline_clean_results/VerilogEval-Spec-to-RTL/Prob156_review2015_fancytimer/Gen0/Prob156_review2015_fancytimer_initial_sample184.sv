module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] remaining;
reg [11:0] counter;
reg [3:0] pattern;
reg [3:0] shift;
reg counting_flag;
reg done_flag;

always @(posedge clk) begin
    if (reset) begin
        // Reset to Idle state
        pattern <= 0;
        shift <= 0;
        delay <= 0;
        remaining <= 0;
        counter <= 0;
        counting_flag <= 0;
        done_flag <= 0;
    end else begin
        case ({pattern[3:1], data})
            4'b1101: begin
                // Start of pattern detected
                pattern <= {pattern[2:0], data};
                if (shift == 4'd0) begin
                    // Start reading delay
                    shift <= 4'd1;
                end else begin
                    // Continue reading delay
                    delay[3] <= data;
                    shift <= shift + 1;
                    if (shift == 4'd4) begin
                        // Finish reading delay
                        remaining <= delay + 1;
                        counting_flag <= 1;
                    end else begin
                        // Shift delay bits
                        delay[3:1] <= {delay[2:0], data};
                    end
                end
            end
            default: begin
                // Continue searching for pattern
                pattern <= {pattern[2:0], data};
                if (!counting_flag) begin
                    shift <= 0;
                end
            end
        endcase

        if (counting_flag) begin
            // Counting state
            if (counter == 1000) begin
                // Decrement remaining time
                remaining <= remaining - 1;
                counter <= 0;
                if (remaining == 0) begin
                    // Finish counting
                    counting_flag <= 0;
                    done_flag <= 1;
                end
            end else begin
                // Increment counter
                counter <= counter + 1;
            end
        end

        if (done_flag && ack) begin
            // Reset to Idle state
            done_flag <= 0;
        end
    end
end

assign count = (counting_flag)? remaining : 4'd0;
assign counting = counting_flag;
assign done = done_flag;

endmodule