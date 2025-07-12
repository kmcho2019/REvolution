module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT1, 2: SHIFT2, 3: SHIFT3, 4: SHIFT4, 5: COUNT, 6: DONE
reg [3:0] delay;
reg [9:0] counter;
reg [3:0] count_out;
reg [3:0] pattern;
reg [2:0] shift_count;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        counter <= 0;
        count_out <= 0;
        pattern <= 0;
        shift_count <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= 1; // SHIFT1
                        pattern <= 0;
                        shift_count <= 0;
                    end else begin
                        pattern <= {pattern[2:0], data};
                    end
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            1: begin // SHIFT1
                delay[3] <= data;
                shift_count <= shift_count + 1;
                if (shift_count == 1) begin
                    state <= 2; // SHIFT2
                end
            end
            2: begin // SHIFT2
                delay[2] <= data;
                shift_count <= shift_count + 1;
                if (shift_count == 2) begin
                    state <= 3; // SHIFT3
                end
            end
            3: begin // SHIFT3
                delay[1] <= data;
                shift_count <= shift_count + 1;
                if (shift_count == 3) begin
                    state <= 4; // SHIFT4
                end
            end
            4: begin // SHIFT4
                delay[0] <= data;
                state <= 5; // COUNT
                counter <= (delay + 1) * 1000;
                count_out <= delay;
            end
            5: begin // COUNT
                counter <= counter - 1;
                if (counter == 0) begin
                    count_out <= count_out - 1;
                    counter <= 1000;
                    if (count_out == 0) begin
                        state <= 6; // DONE
                    end
                end
            end
            6: begin // DONE
                if (ack) begin
                    state <= 0; // IDLE
                end
            end
        endcase
    end
end

assign count = (state == 5) ? count_out : 4'bxxxx;
assign counting = (state == 5);
assign done = (state == 6);

endmodule