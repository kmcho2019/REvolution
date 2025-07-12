module TopModule(
    input        clk,
    input        reset,
    input        data,
    output [3:0] count,
    output       counting,
    output       done,
    input        ack
);

// State definition
enum logic [2:0] {
    Idle,
    ShiftDelay,
    Count,
    Done
} state, nextState;

// Registers
logic [3:0] delay;
logic [3:0] count_reg;
logic [9:0] cycle_counter;
logic       counting_reg;

// Shift register for input pattern detection
logic [3:0] shift_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        state         <= Idle;
        shift_reg     <= 4'b0000;
        delay         <= 4'b0000;
        count_reg     <= 4'b0000;
        cycle_counter <= 10'b0000000000;
        counting_reg  <= 1'b0;
    end else begin
        case (state)
            Idle: begin
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg == 4'b1101) begin
                    state <= ShiftDelay;
                end
            end
            ShiftDelay: begin
                delay <= {data, delay[3:1]};
                if (delay[3:1] == 3'b111) begin
                    state <= Count;
                    cycle_counter <= 10'b0000000000;
                    count_reg      <= delay;
                    counting_reg   <= 1'b1;
                end else if (delay[3:1] == 3'b000) begin
                    state <= Count;
                    cycle_counter <= 10'b0000000000;
                    count_reg      <= delay;
                    counting_reg   <= 1'b1;
                end
            end
            Count: begin
                if (cycle_counter == 10'b1111101000) begin
                    cycle_counter <= 10'b0000000000;
                    if (count_reg > 4'b0000) begin
                        count_reg <= count_reg - 1'b1;
                    end else begin
                        state     <= Done;
                        counting_reg <= 1'b0;
                    end
                end else begin
                    cycle_counter <= cycle_counter + 1'b1;
                end
            end
            Done: begin
                if (ack) begin
                    state <= Idle;
                end
            end
            default: state <= Idle;
        endcase
    end
end

assign counting = counting_reg;
assign done     = (state == Done);
assign count    = (state == Count)? count_reg : 4'b0000;

endmodule