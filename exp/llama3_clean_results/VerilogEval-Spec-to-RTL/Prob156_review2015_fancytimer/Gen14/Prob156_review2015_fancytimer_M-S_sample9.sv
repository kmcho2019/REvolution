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
reg [3:0] sequence;
reg [2:0] state;

parameter IDLE = 3'b001;
parameter SHIFT_DELAY = 3'b010;
parameter COUNTING = 3'b100;
parameter DONE = 3'b111;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        count <= 4'd0;
        sequence <= 4'd0;
        counter <= 20'd0;
        delay <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                sequence <= {sequence[2:0], data};
                if (sequence == 4'b1101) begin
                    state <= SHIFT_DELAY;
                    sequence <= 4'b0;
                end
            end
            SHIFT_DELAY: begin
                if (sequence == 4'd0) begin
                    delay[3] <= data;
                end
                else if (sequence == 4'd1) begin
                    delay[2] <= data;
                end
                else if (sequence == 4'd2) begin
                    delay[1] <= data;
                end
                else if (sequence == 4'd3) begin
                    delay[0] <= data;
                    state <= COUNTING;
                    counter <= 20'd0;
                    counting <= 1'b1;
                end
                sequence <= sequence + 1;
            end
            COUNTING: begin
                counter <= counter + 1;
                if (counter == (delay + 1) * 1000 - 1) begin
                    state <= DONE;
                    counting <= 1'b0;
                end
                if (counter % 1000 == 0 && counter!= 0) begin
                    delay <= delay - 1;
                    count <= delay;
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