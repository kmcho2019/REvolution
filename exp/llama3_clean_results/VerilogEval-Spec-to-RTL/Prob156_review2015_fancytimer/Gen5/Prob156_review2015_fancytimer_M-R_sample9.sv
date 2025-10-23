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
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case (state)
        IDLE: begin
            next_state = (seq_reg == 4'b1101) ? SHIFT : IDLE;
            counting = 1'b0;
            done = 1'b0;
        end
        SHIFT: begin
            next_state = (counter == 4'd3) ? COUNT : SHIFT;
            counting = 1'b0;
            done = 1'b0;
        end
        COUNT: begin
            next_state = (counter == (delay + 1) * 1000 - 1) ? DONE : COUNT;
            counting = 1'b1;
            done = 1'b0;
        end
        DONE: begin
            next_state = (ack == 1'b1) ? IDLE : DONE;
            counting = 1'b0;
            done = 1'b1;
        end
    endcase
end

// Update seq_reg, delay, counter, and remaining_time
always @(posedge clk) begin
    case (state)
        IDLE: begin
            seq_reg <= {seq_reg[2:0], data};
        end
        SHIFT: begin
            delay <= {data, delay[3:1]};
            counter <= counter + 1;
        end
        COUNT: begin
            counter <= counter + 1;
            if (counter % 1000 == 0) begin
                remaining_time <= remaining_time - 1;
            end
        end
    endcase
end

// Assign output signals
assign count = (state == COUNT) ? remaining_time : 4'bxxxx;

endmodule