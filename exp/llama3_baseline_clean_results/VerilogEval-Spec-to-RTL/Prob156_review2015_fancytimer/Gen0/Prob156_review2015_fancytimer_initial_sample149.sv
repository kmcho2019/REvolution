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
reg [3:0] remaining_time;
reg [9:0] counter;
reg [3:0] shift_reg;
reg        start_detected;
reg        counting_flag;

always @(posedge clk) begin
    if (reset) begin
        delay <= 4'd0;
        remaining_time <= 4'd0;
        counter <= 10'd0;
        shift_reg <= 4'd0;
        start_detected <= 1'b0;
        counting_flag <= 1'b0;
        count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case ({start_detected, counting_flag, done})
            3'b000: begin // IDLE
                if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
                if (shift_reg == 4'b1101) begin
                    start_detected <= 1'b1;
                end else begin
                    shift_reg <= 4'd0;
                end
            end
            3'b001: begin // SHIFT
                if (data) begin
                    delay <= {delay[2:0], 1'b1};
                end else begin
                    delay <= {delay[2:0], 1'b0};
                end
                counting_flag <= 1'b1;
                start_detected <= 1'b0;
                remaining_time <= delay;
                counter <= 10'd0;
            end
            3'b010: begin // COUNT
                if (counter == 10'd999) begin
                    remaining_time <= remaining_time - 1'b1;
                    counter <= 10'd0;
                end else begin
                    counter <= counter + 1'b1;
                end
                if (remaining_time == 4'd0) begin
                    done <= 1'b1;
                    counting_flag <= 1'b0;
                end
                counting <= 1'b1;
                count <= remaining_time;
            end
            3'b011: begin // DONE
                if (ack) begin
                    done <= 1'b0;
                    counting_flag <= 1'b0;
                    start_detected <= 1'b0;
                end
            end
            default: begin
                // Do nothing
            end
        endcase
    end
end

endmodule