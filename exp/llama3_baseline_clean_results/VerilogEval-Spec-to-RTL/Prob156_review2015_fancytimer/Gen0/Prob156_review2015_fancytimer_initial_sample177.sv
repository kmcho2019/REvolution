module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] remaining;
reg [9:0] cycle_count;
reg pattern_detected;
reg [3:0] pattern_shift;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000; // IDLE
        pattern_detected <= 1'b0;
        pattern_shift <= 4'b0000;
        cycle_count <= 10'b0000000000;
        remaining <= 4'b0000;
        delay <= 4'b0000;
    end else begin
        case (state)
            4'b0000: begin // IDLE
                if (pattern_detected) begin
                    state <= 4'b0001; // PATTERN_SEARCH
                    pattern_detected <= 1'b0;
                end else begin
                    if (pattern_shift == 4'b1101) begin
                        pattern_detected <= 1'b1;
                    end else begin
                        pattern_shift <= {pattern_shift[2:0], data};
                    end
                end
            end
            4'b0001: begin // PATTERN_SEARCH
                state <= 4'b0010; // DELAY_SHIFT
                delay <= 4'b0000;
                pattern_shift <= 4'b0000;
            end
            4'b0010: begin // DELAY_SHIFT
                pattern_shift <= {pattern_shift[2:0], data};
                if (pattern_shift == 4'b1000) begin
                    delay[3] <= data;
                    state <= 4'b0011;
                end else if (pattern_shift == 4'b0100) begin
                    delay[2] <= data;
                    state <= 4'b0100;
                end else if (pattern_shift == 4'b0010) begin
                    delay[1] <= data;
                    state <= 4'b0101;
                end else if (pattern_shift == 4'b0001) begin
                    delay[0] <= data;
                    state <= 4'b0110; // COUNTING
                    remaining <= delay + 1;
                    cycle_count <= 10'b0000000000;
                end
            end
            4'b0011: begin
                delay[3] <= data;
                pattern_shift <= {pattern_shift[2:0], data};
                if (pattern_shift == 4'b1000) begin
                    delay[2] <= data;
                    state <= 4'b0100;
                end
            end
            4'b0100: begin
                delay[2] <= data;
                pattern_shift <= {pattern_shift[2:0], data};
                if (pattern_shift == 4'b1000) begin
                    delay[1] <= data;
                    state <= 4'b0101;
                end
            end
            4'b0101: begin
                delay[1] <= data;
                pattern_shift <= {pattern_shift[2:0], data};
                if (pattern_shift == 4'b1000) begin
                    delay[0] <= data;
                    state <= 4'b0110; // COUNTING
                    remaining <= delay + 1;
                    cycle_count <= 10'b0000000000;
                end
            end
            4'b0110: begin // COUNTING
                cycle_count <= cycle_count + 1;
                if (cycle_count == 10'b1111101000) begin
                    cycle_count <= 10'b0000000000;
                    remaining <= remaining - 1;
                    if (remaining == 4'b0000) begin
                        state <= 4'b0111; // DONE
                    end
                end
            end
            4'b0111: begin // DONE
                if (ack) begin
                    state <= 4'b0000; // IDLE
                    pattern_shift <= 4'b0000;
                end
            end
        endcase
    end
end

assign count = (state == 4'b0110) ? remaining : 4'bxxxx;
assign counting = (state == 4'b0110) ? 1'b1 : 1'b0;
assign done = (state == 4'b0111) ? 1'b1 : 1'b0;

endmodule