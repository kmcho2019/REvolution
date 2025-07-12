module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] sequence;
reg [3:0] delay;
reg [19:0] counter;
reg [3:0] current_count;
reg [1:0] state;

parameter IDLE = 2'b00;
parameter DETECT_SEQUENCE = 2'b01;
parameter DETECT_DELAY = 2'b10;
parameter COUNTING = 2'b11;
parameter DONE = 2'b00;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        count <= 4'd0;
        sequence <= 4'd0;
        counter <= 20'd0;
        delay <= 4'd0;
        current_count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                sequence <= {sequence[2:0], data};
                if (sequence == 4'b1101) begin
                    state <= DETECT_DELAY;
                    sequence <= 4'd0;
                    counter <= 20'd0;
                end
            end
            DETECT_DELAY: begin
                delay <= {delay[2:0], data};
                counter <= counter + 1;
                if (counter == 4'd3) begin
                    state <= COUNTING;
                    counter <= 20'd0;
                    current_count <= delay;
                end
            end
            COUNTING: begin
                counter <= counter + 1;
                if (counter == 20'd999) begin
                    counter <= 20'd0;
                    current_count <= current_count - 1;
                    count <= current_count;
                end
                counting <= 1'b1;
                if (current_count == 4'd0) begin
                    state <= DONE;
                    counting <= 1'b0;
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