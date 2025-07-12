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
reg [19:0] counter;
reg [3:0] delay_counter;
reg [3:0] sequence;
reg [2:0] state;

parameter IDLE = 3'b001;
parameter DETECT_DELAY = 3'b010;
parameter COUNTING = 3'b100;
parameter DONE = 3'b111;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        count <= 4'd0;
        sequence <= 4'd0;
        counter <= 20'd0;
        delay <= 4'd0;
        delay_counter <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                sequence <= {sequence[2:0], data};
                if (sequence == 4'b1101) begin
                    state <= DETECT_DELAY;
                end
            end
            DETECT_DELAY: begin
                if (delay_counter == 4'd0) begin
                    delay[3] <= data;
                end
                else if (delay_counter == 4'd1) begin
                    delay[2] <= data;
                end
                else if (delay_counter == 4'd2) begin
                    delay[1] <= data;
                end
                else if (delay_counter == 4'd3) begin
                    delay[0] <= data;
                    state <= COUNTING;
                    delay_counter <= delay;
                    counter <= 20'd0;
                    counting <= 1'b1;
                end
                delay_counter <= delay_counter + 1;
            end
            COUNTING: begin
                counter <= counter + 1;
                if (counter == 20'd999) begin
                    counter <= 20'd0;
                    delay_counter <= delay_counter - 1;
                    count <= delay_counter;
                end
                if (delay_counter == 4'd0) begin
                    state <= DONE;
                    counting <= 1'b0;
                end
            end
            DONE: begin
                done <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule