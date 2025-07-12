module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

// States
enum logic [2:0] {
    Idle,
    PatternFound,
    Counting,
    Done
} state, nextState;

// Registers
logic [3:0] delay;
logic [9:0] counter;
logic [3:0] current_count;
logic pattern_detected;

// Shift register for pattern detection
logic [3:0] shift_reg;

// Pattern detection logic
always_ff @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000;
        pattern_detected <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[2:0], data};
        pattern_detected <= (shift_reg == 4'b1101) ? 1'b1 : 1'b0;
    end
end

// FSM logic
always_comb begin
    case (state)
        Idle: begin
            if (pattern_detected) begin
                nextState = PatternFound;
            end else begin
                nextState = Idle;
            end
        end
        PatternFound: begin
            if (counter == 4) begin
                nextState = Counting;
            end else begin
                nextState = PatternFound;
            end
        end
        Counting: begin
            if (current_count == 0 && counter == 0) begin
                nextState = Done;
            end else begin
                nextState = Counting;
            end
        end
        Done: begin
            if (ack) begin
                nextState = Idle;
            end else begin
                nextState = Done;
            end
        end
        default: nextState = Idle;
    endcase
end

// Counter logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        counter <= 10'b0000000000;
        current_count <= 4'b0000;
        delay <= 4'b0000;
        count <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        state <= nextState;
        case (state)
            Idle: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'bxxxx;
            end
            PatternFound: begin
                if (counter < 4) begin
                    counter <= counter + 1;
                    delay[3 - counter] <= data;
                end
            end
            Counting: begin
                counting <= 1'b1;
                if (current_count > 0) begin
                    current_count <= current_count - 1;
                    count <= current_count;
                end else if (counter > 0) begin
                    counter <= counter - 1;
                    current_count <= delay + 1;
                    count <= current_count;
                end
            end
            Done: begin
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'bxxxx;
            end
            default: ;
        endcase
    end
end

endmodule