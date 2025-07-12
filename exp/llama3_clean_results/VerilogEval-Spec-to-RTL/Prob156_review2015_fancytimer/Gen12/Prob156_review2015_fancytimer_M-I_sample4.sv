module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// Parameters
parameter SEQUENCE_BITS = 4;
parameter DELAY_BITS = 4;
parameter COUNTER_BITS = 20;

// Registers
reg [SEQUENCE_BITS-1:0] seq_reg;
reg [DELAY_BITS-1:0] delay_reg;
reg [COUNTER_BITS-1:0] counter;
reg [DELAY_BITS-1:0] remaining_delay;

// Finite State Machine (FSM) states
enum {IDLE, DELAY_REG, COUNTING, DONE} state, next_state;

// Sequence detection and delay registration
always @(posedge clk or posedge reset) begin
    if (reset) begin
        seq_reg <= 0;
        delay_reg <= 0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                seq_reg <= {seq_reg[SEQUENCE_BITS-2:0], data};
                if (seq_reg == 4'b1101) begin
                    state <= DELAY_REG;
                end
            end
            DELAY_REG: begin
                delay_reg <= {data, delay_reg[DELAY_BITS-1:1]};
                if (delay_reg[0] == 1'b1) begin
                    state <= COUNTING;
                    counter <= (delay_reg + 1) * 1000 - 1;
                    remaining_delay <= delay_reg;
                end
            end
            COUNTING: begin
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        remaining_delay <= remaining_delay - 1;
                    end
                end else begin
                    state <= DONE;
                end
            end
            DONE: begin
                if (ack == 1'b1) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Output assignments
always @(*) begin
    case (state)
        IDLE: begin
            counting = 1'b0;
            done = 1'b0;
            count = 4'b0000;
        end
        DELAY_REG: begin
            counting = 1'b0;
            done = 1'b0;
            count = 4'b0000;
        end
        COUNTING: begin
            counting = 1'b1;
            done = 1'b0;
            count = remaining_delay;
        end
        DONE: begin
            counting = 1'b0;
            done = 1'b1;
            count = 4'b0000;
        end
    endcase
end

endmodule