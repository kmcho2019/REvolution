module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [1:0] state;
reg [3:0] pattern;
reg [3:0] delay;
reg [3:0] delay_counter;

localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNTING = 2'b10;
localparam DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        delay <= 4'b0000;
        delay_counter <= 4'b0000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    delay_counter <= 4'b0000;
                    shift_ena <= 1'b1;
                end else begin
                    shift_ena <= 1'b0;
                end
            end
            SHIFT: begin
                delay[3:1] <= delay[2:0];
                delay[0] <= data;
                if (delay_counter == 4'b1000) begin
                    state <= COUNTING;
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    delay_counter <= 4'b0000;
                end else begin
                    delay_counter <= delay_counter + 1'b1;
                    shift_ena <= 1'b1;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    counting <= 1'b0;
                    state <= DONE;
                    done <= 1'b1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule