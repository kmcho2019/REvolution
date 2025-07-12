module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] remaining_time;
reg [9:0] counter;
reg [3:0] shift_reg;

// States
localparam IDLE = 4'd0;
localparam SHIFT = 4'd1;
localparam COUNT = 4'd2;
localparam DONE = 4'd3;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        shift_reg <= 4'd0;
        remaining_time <= 4'd0;
        counter <= 10'd0;
    end
    else begin
        case (state)
            IDLE: begin
                if (shift_reg == 4'd13) begin // 1101 in binary is 13 in decimal
                    state <= SHIFT;
                    shift_reg <= 4'd0;
                end
                else if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end
                else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end

            SHIFT: begin
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg == 4'd15) begin // all 4 bits have been shifted in
                    delay <= shift_reg;
                    state <= COUNT;
                    remaining_time <= delay + 1;
                    counter <= 10'd0;
                    counting <= 1'b1;
                end
            end

            COUNT: begin
                if (counter == 10'd999) begin // 1000 cycles have passed
                    counter <= 10'd0;
                    remaining_time <= remaining_time - 1;
                    if (remaining_time == 1) begin
                        state <= DONE;
                        counting <= 1'b0;
                    end
                end
                else begin
                    counter <= counter + 1;
                end
                count <= remaining_time;
            end

            DONE: begin
                done <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end

            default: state <= IDLE;

        endcase
    end
end

endmodule