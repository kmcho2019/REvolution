module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [1:0] state;
reg [3:0] delay;
reg [9:0] remaining_time;
reg [3:0] pattern;
reg [3:0] shift_count;
reg [9:0] tick_count;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        remaining_time <= 0;
        tick_count <= 0;
        shift_count <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1'b1) begin
                    pattern <= {data, pattern[2:0]};
                    if (pattern == 4'b1101) begin
                        state <= 1; // SHIFT
                    end
                end else begin
                    pattern <= 0;
                end
            end
            1: begin // SHIFT
                delay <= {data, delay[2:0]}; // shift in delay value
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin // check if all 4 bits have been shifted
                    remaining_time <= (delay + 1) * 1000;
                    state <= 2; // COUNT
                end
            end
            2: begin // COUNT
                tick_count <= tick_count + 1;
                if (tick_count == 1000) begin
                    tick_count <= 0;
                    remaining_time <= remaining_time - 1000;
                    if (remaining_time <= 0) begin
                        state <= 3; // DONE
                    end
                end
            end
            3: begin // DONE
                if (ack) begin // check for acknowledgement
                    state <= 0; // IDLE
                end
            end
        endcase
    end
end

assign count = (remaining_time >= 1000) ? (remaining_time / 1000) : 0;
assign counting = (state == 2);
assign done = (state == 3);

endmodule