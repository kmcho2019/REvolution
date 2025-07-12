module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [1:0] state; // 0: IDLE, 1: COUNT, 2: DONE
reg [3:0] delay; // delay value
reg [9:0] cycle_count; // counter for clock cycles
reg [3:0] remaining_time; // remaining time
reg [3:0] pattern; // input pattern
reg counting_reg; // counting output
reg done_reg; // done output
reg [1:0] shift_count; // counter for shifting

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        counting_reg <= 0;
        done_reg <= 0;
        pattern <= 0;
        delay <= 0;
        cycle_count <= 0;
        remaining_time <= 0;
        shift_count <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (pattern[3:0] == 4'b1101) begin
                    state <= 1; // move to COUNT state
                    delay <= pattern[7:4]; // store delay value
                    remaining_time <= delay + 1; // calculate remaining time
                    counting_reg <= 1;
                    cycle_count <= 0;
                end else if (pattern[3:1] == 3'b110) begin
                    pattern <= {data, pattern[6:0]}; // shift in pattern
                    shift_count <= shift_count + 1;
                    if (shift_count == 3) begin
                        pattern <= {data, pattern[6:0]};
                    end
                end else begin
                    pattern <= {data, pattern[6:0]}; // shift in pattern
                end
            end
            1: begin // COUNT state
                cycle_count <= cycle_count + 1;
                if (cycle_count == 1000) begin // check if 1000 cycles have passed
                    cycle_count <= 0;
                    remaining_time <= remaining_time - 1;
                    if (remaining_time == 0) begin
                        state <= 2; // move to DONE state
                        counting_reg <= 0;
                    end
                end
            end
            2: begin // DONE state
                done_reg <= 1;
                if (ack) begin // check for acknowledgement
                    state <= 0; // reset to IDLE state
                    done_reg <= 0;
                    counting_reg <= 0;
                    pattern <= 0;
                    delay <= 0;
                    cycle_count <= 0;
                    remaining_time <= 0;
                    shift_count <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;
assign count = remaining_time - 1;

endmodule