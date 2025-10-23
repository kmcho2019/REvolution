module TopModule(
    input         clk,
    input         reset,
    input         data,
    input         done_counting,
    input         ack,
    output        shift_ena,
    output        counting,
    output        done
);

// Define states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Define a shift register to store incoming data
logic [3:0] data_shift;

// IDLE state: Look for pattern 1101
always_comb begin
    case(state)
        IDLE: begin
            if(data_shift == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if(data_shift[3] == 1'b1) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if(done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            if(ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic for state and data_shift registers
always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        data_shift <= 4'b0000;
    end else begin
        state <= next_state;
        // Shift in data for pattern detection and duration
        if(state == IDLE) begin
            data_shift <= {data, data_shift[3:1]};
        end else if(state == SHIFT) begin
            data_shift[3:0] <= {data, data_shift[3:1]};
        end
    end
end

// Combinational logic for outputs
always_comb begin
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    case(state)
        SHIFT: begin
            shift_ena = 1'b1;
        end
        COUNT: begin
            counting = 1'b1;
        end
        DONE: begin
            done = 1'b1;
        end
        default: ;
    endcase
end

endmodule