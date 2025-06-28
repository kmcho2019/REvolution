module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

typedef enum logic [1:0] { IDLE, SEARCH_PATTERN, READ_DELAY, COUNTING, WAIT_ACK } state_t;
reg [1:0] state;
reg [3:0] delay;
reg [31:0] timer;

always_ff @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counting <= 0;
        done <= 0;
        count <= 4'bxxxx;
        timer <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data == 4'b1101) begin
                    state <= SEARCH_PATTERN;
                end
            end
            SEARCH_PATTERN: begin
                if (data == 4'b1101) begin
                    state <= READ_DELAY;
                end
            end
            READ_DELAY: begin
                delay <= {data, delay[3:1]};
                state <= COUNTING;
                counting <= 1;
                timer <= (delay + 1) * 1000 - 1;
                count <= delay;
            end
            COUNTING: begin
                if (timer > 0) begin
                    timer <= timer - 1;
                    if (timer % 1000 == 0) begin
                        if (delay > 0)
                            delay <= delay - 1;
                        count <= delay;
                    end
                end
                else begin
                    state <= WAIT_ACK;
                    counting <= 0;
                    done <= 1;
                end
            end
            WAIT_ACK: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                    count <= 4'bxxxx;
                    timer <= 0;
                end
            end
        endcase
    end
end

endmodule