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
reg [1:0] state; // 2-bit state machine

parameter IDLE = 2'b00;
parameter DETECT_DELAY = 2'b01;
parameter COUNTING = 2'b10;
parameter DONE_STATE = 2'b11;

// Combinational Logic for Next State
always @(*) begin
    case (state)
        IDLE: begin
            if (sequence == 4'b1101) begin
                state <= DETECT_DELAY;
            end
            else begin
                state <= IDLE;
            end
        end
        DETECT_DELAY: begin
            if (counter == 20'd4) begin
                state <= COUNTING;
            end
            else begin
                state <= DETECT_DELAY;
            end
        end
        COUNTING: begin
            if (delay == 4'd0 && counter == 20'd1000) begin
                state <= DONE_STATE;
            end
            else begin
                state <= COUNTING;
            end
        end
        DONE_STATE: begin
            if (ack) begin
                state <= IDLE;
            end
            else begin
                state <= DONE_STATE;
            end
        end
        default: state <= IDLE;
    endcase
end

// Sequential Logic
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
            end
            DETECT_DELAY: begin
                if (counter < 20'd4) begin
                    case (counter)
                        20'd0: delay[3] <= data;
                        20'd1: delay[2] <= data;
                        20'd2: delay[1] <= data;
                        20'd3: delay[0] <= data;
                    endcase
                    counter <= counter + 1;
                end
            end
            COUNTING: begin
                if (counter < 20'd1000) begin
                    counter <= counter + 1;
                end
                else begin
                    counter <= 20'd0;
                    delay <= delay - 1;
                    count <= delay;
                end
                counting <= 1'b1;
            end
            DONE_STATE: begin
                counting <= 1'b0;
                done <= 1'b1;
                if (ack) begin
                    done <= 1'b0;
                    counter <= 20'd0;
                    delay <= 4'd0;
                    count <= 4'd0;
                end
            end
        endcase
    end
end

endmodule