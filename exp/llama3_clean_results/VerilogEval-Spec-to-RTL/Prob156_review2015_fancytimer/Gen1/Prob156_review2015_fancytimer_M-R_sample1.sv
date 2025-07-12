module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [3:0] remaining;
reg [3:0] pattern_counter;
reg [9:0] cycle_counter;
reg [1:0] state;
reg seq_match;

assign seq_match = (pattern_counter == 4'b1101);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        remaining <= 0;
        pattern_counter <= 0;
        cycle_counter <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (seq_match) begin
                    state <= 1;
                    pattern_counter <= 0;
                end else if (data == 1'b1) begin
                    pattern_counter <= {pattern_counter[2:0], 1'b1};
                end else if (data == 1'b0) begin
                    pattern_counter <= {pattern_counter[2:0], 1'b0};
                end
            end
            1: begin // SHIFT
                if (cycle_counter == 10'd3) begin
                    delay <= {delay[2:0], data};
                    state <= 2;
                    cycle_counter <= 0;
                    remaining <= delay + 1;
                end else begin
                    delay <= {delay[2:0], data};
                    cycle_counter <= cycle_counter + 1;
                end
            end
            2: begin // COUNT
                counting <= 1'b1;
                if (cycle_counter == 10'd999) begin
                    cycle_counter <= 0;
                    remaining <= remaining - 1;
                    count <= remaining;
                    if (remaining == 0) begin
                        state <= 3;
                    end
                end else begin
                    cycle_counter <= cycle_counter + 1;
                    count <= remaining;
                end
            end
            3: begin // DONE
                done <= 1'b1;
                counting <= 0;
                if (ack == 1'b1) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule