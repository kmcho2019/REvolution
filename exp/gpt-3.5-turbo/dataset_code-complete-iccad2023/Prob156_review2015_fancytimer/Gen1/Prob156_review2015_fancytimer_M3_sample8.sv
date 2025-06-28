module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count = 4'bxxxx,
  output reg counting = 0,
  output reg done = 0,
  input wire ack
);

typedef enum logic [1:0] {
    SEARCH,
    RECEIVE,
    COUNT,
    DONE
} state_t;

reg [1:0] state;
reg [3:0] delay;
reg [11:0] counter;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= SEARCH;
        count <= 4'bxxxx;
        counting <= 0;
        done <= 0;
        counter <= 0;
        delay <= 4'b0;
    end
    else begin
        case(state)
            SEARCH: begin
                if (data == 4'b1101) begin
                    state <= RECEIVE;
                    counter <= 3;
                end
            end
            RECEIVE: begin
                if (counter == 0) begin
                    delay <= data;
                    state <= COUNT;
                    counting <= 1;
                    count <= delay;
                    counter <= (delay + 1) * 1000 - 1;
                end
            end
            COUNT: begin
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter == 0) begin
                        if (delay == 0)
                            state <= DONE;
                        else begin
                            delay <= delay - 1;
                            counter <= delay * 1000 - 1;
                            count <= delay;
                        end
                    end
                end
            end
            DONE: begin
                if (ack) begin
                    state <= SEARCH;
                    counting <= 0;
                    done <= 1;
                end
            end
        endcase
    end
end

endmodule