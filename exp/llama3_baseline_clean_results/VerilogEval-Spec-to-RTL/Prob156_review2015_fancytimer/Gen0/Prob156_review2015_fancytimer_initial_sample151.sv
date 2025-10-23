module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state; // 0: idle, 1: delay_capture, 2: counting, 3: done
reg [3:0] delay; // delay value
reg [9:0] remaining_time; // remaining time counter
reg [3:0] count_out; // output count
reg counting_out;
reg done_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 4'b0000; // idle
        counting_out <= 1'b0;
        done_out <= 1'b0;
        count_out <= 4'b0000;
    end else begin
        case (state)
            4'b0000: begin // idle
                if (data == 1'b1) begin
                    state <= 4'b0001; // capture first bit of pattern
                end
            end
            4'b0001: begin // capture first bit of pattern
                if (data == 1'b1) begin
                    state <= 4'b0010; // capture second bit of pattern
                end else begin
                    state <= 4'b0000; // reset pattern detection
                end
            end
            4'b0010: begin // capture second bit of pattern
                if (data == 1'b0) begin
                    state <= 4'b0011; // capture third bit of pattern
                end else begin
                    state <= 4'b0000; // reset pattern detection
                end
            end
            4'b0011: begin // capture third bit of pattern
                if (data == 1'b1) begin
                    state <= 4'b0100; // capture delay
                end else begin
                    state <= 4'b0000; // reset pattern detection
                end
            end
            4'b0100: begin // capture delay
                delay <= {data, delay[2:0]}; // shift in delay bit
                if (delay[0] == 1'b1) begin
                    state <= 4'b0101; // start counting
                    remaining_time <= ({delay, 4'b0000} + 1) * 10'd1000;
                    counting_out <= 1'b1;
                end
            end
            4'b0101: begin // counting
                if (remaining_time > 10'd0) begin
                    remaining_time <= remaining_time - 10'd1;
                    if (remaining_time[9:4] == 10'b000000) begin
                        count_out <= remaining_time[3:0];
                    end
                end else begin
                    state <= 4'b0110; // done
                    counting_out <= 1'b0;
                    done_out <= 1'b1;
                end
            end
            4'b0110: begin // done
                if (ack == 1'b1) begin
                    state <= 4'b0000; // idle
                    done_out <= 1'b0;
                end
            end
        endcase
    end
end

assign count = count_out;
assign counting = counting_out;
assign done = done_out;

endmodule