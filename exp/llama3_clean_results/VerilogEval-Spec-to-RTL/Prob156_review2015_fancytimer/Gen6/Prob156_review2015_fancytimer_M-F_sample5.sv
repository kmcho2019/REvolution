module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

typedef enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state_t;

state_t state, next_state;
reg [3:0] delay;
reg [19:0] counter;
reg [3:0] seq_reg;
reg [3:0] remaining_time;

// Next state logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        seq_reg <= 4'b0000;
        delay <= 4'b0000;
        counter <= 20'b0;
        remaining_time <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (seq_reg == 4'b1101) begin
                    state <= SHIFT;
                end else begin
                    state <= IDLE;
                    seq_reg <= {seq_reg[2:0], data};
                end
            end
            SHIFT: begin
                if (counter == 4'd3) begin
                    state <= COUNT;
                    remaining_time <= delay + 1;
                end else begin
                    state <= SHIFT;
                    delay <= {data, delay[3:1]};
                    counter <= counter + 1;
                end
            end
            COUNT: begin
                if (counter == (delay + 1) * 1000 - 1) begin
                    state <= DONE;
                end else begin
                    state <= COUNT;
                    counter <= counter + 1;
                    if (counter % 1000 == 0) begin
                        remaining_time <= remaining_time - 1;
                    end
                end
            end
            DONE: begin
                if (ack == 1'b1) begin
                    state <= IDLE;
                end else begin
                    state <= DONE;
                end
            end
        endcase
    end
end

// Output logic
always @(*) begin
    case (state)
        IDLE: begin
            counting = 1'b0;
            done = 1'b0;
            count = 4'bxxxx;
        end
        SHIFT: begin
            counting = 1'b0;
            done = 1'b0;
            count = 4'bxxxx;
        end
        COUNT: begin
            counting = 1'b1;
            done = 1'b0;
            count = remaining_time;
        end
        DONE: begin
            counting = 1'b0;
            done = 1'b1;
            count = 4'bxxxx;
        end
    endcase
end

endmodule