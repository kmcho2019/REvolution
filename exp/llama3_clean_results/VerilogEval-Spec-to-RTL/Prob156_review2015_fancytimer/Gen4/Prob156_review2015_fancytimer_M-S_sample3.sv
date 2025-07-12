module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] delay; // delay value
reg [9:0] remaining_time; // remaining time
reg [3:0] shift_count; // counter for shifting delay
reg counting_reg; // counting output
reg done_reg; // done output

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        counting_reg <= 0;
        done_reg <= 0;
        shift_count <= 0;
        delay <= 0;
        remaining_time <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data == 1'b1) begin
                    shift_count <= shift_count + 1;
                    if (shift_count == 1) begin
                        if (data == 1'b1) begin
                            state <= 1; // move to SHIFT state
                        end
                    end
                end else begin
                    shift_count <= 0;
                end
            end
            1: begin // SHIFT state
                delay <= {data, delay[2:0]}; // shift in delay value
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin // check if all 4 bits have been shifted
                    state <= 2; // move to COUNT state
                    counting_reg <= 1;
                    remaining_time <= (delay + 1) * 1000;
                end
            end
            2: begin // COUNT state
                remaining_time <= remaining_time - 1;
                if (remaining_time == 0) begin
                    state <= 3; // move to DONE state
                    counting_reg <= 0;
                end
            end
            3: begin // DONE state
                done_reg <= 1;
                if (ack) begin // check for acknowledgement
                    state <= 0; // reset to IDLE state
                    done_reg <= 0;
                    shift_count <= 0;
                    delay <= 0;
                    remaining_time <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;
assign count = (remaining_time > 999) ? (remaining_time / 1000) : 0;

endmodule