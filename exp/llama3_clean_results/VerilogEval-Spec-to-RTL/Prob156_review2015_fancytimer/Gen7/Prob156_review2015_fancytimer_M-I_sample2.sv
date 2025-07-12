module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

enum logic [1:0] {IDLE, SHIFT, COUNT, DONE} state, next_state;
reg [3:0] delay;
reg [3:0] shift_count;
reg [3:0] pattern;
reg [9:0] counter;
reg [9:0] target_count;

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 0;
        shift_count <= 0;
        pattern <= 0;
        counter <= 0;
        target_count <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern <= {data, pattern[2:0]};
                    if (pattern == 4'b1101) begin
                        next_state <= SHIFT;
                    end else begin
                        next_state <= IDLE;
                    end
                end else begin
                    pattern <= 0;
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                delay <= {data, delay[2:0]};
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    next_state <= COUNT;
                    target_count <= (delay + 1) * 1000;
                    counter <= 0;
                end else begin
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                counter <= counter + 1;
                if (counter == target_count) begin
                    next_state <= DONE;
                end else begin
                    next_state <= COUNT;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= DONE;
                end
            end
            default: next_state <= IDLE;
        endcase
        state <= next_state;
    end
end

assign count = (state == COUNT) ? (delay - (counter / 1000)) : 0;
assign counting = (state == COUNT);
assign done = (state == DONE);

endmodule