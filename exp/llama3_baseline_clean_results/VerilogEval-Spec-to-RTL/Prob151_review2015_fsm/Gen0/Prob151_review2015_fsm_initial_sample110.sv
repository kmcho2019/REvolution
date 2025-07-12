module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

// Define states
parameter IDLE = 4'b0000, SHIFT = 4'b0001, COUNT = 4'b0010, DONEWAIT = 4'b0011, WAIT_ACK = 4'b0100;

// Internal state and shift counter
reg [3:0] state;
reg [1:0] shift_cnt;

// Initial state
initial state = IDLE;
initial shift_cnt = 2'b00;

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        shift_cnt <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                // Assuming the pattern is 1101, implement the detection logic
                // Here we assume the pattern is received in 4 clock cycles
                reg [3:0] pattern = 4'b1101;
                reg [3:0] data_reg = {data, data, data, data};
                if (data_reg == pattern) begin
                    state <= SHIFT;
                    shift_cnt <= 2'b00;
                end
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                if (shift_cnt == 2'b11) begin
                    state <= COUNT;
                end else begin
                    shift_cnt <= shift_cnt + 1'b1;
                end
                counting <= 1'b0;
                done <= 1'b0;
            end
            COUNT: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                if (done_counting) begin
                    state <= DONEWAIT;
                end
                done <= 1'b0;
            end
            DONEWAIT: begin
                counting <= 1'b0;
                done <= 1'b1;
                if (ack) begin
                    state <= WAIT_ACK;
                end
            end
            WAIT_ACK: begin
                done <= 1'b0;
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule