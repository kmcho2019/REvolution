module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

// Define states
enum logic [2:0] {IDLE, SHIFTING, COUNTING, DONE} state, next_state;

// Define internal signals
logic [3:0] shift_count;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    next_state = state;
    case(state)
        IDLE: begin
            if (data == 1'b1 && (shift_count == 4'b1101)) begin
                next_state = SHIFTING;
            end else if (data == 1'b1 && (shift_count == 4'b110)) begin
                shift_count <= {1'b1, shift_count[2:0]};
            end else if (data == 1'b0 && (shift_count == 4'b11)) begin
                shift_count <= {1'b0, shift_count[2:1]};
            end else if (data == 1'b1 && (shift_count == 4'b1)) begin
                shift_count <= {1'b1, shift_count[2:0]};
            end else if (data == 1'b1 && (shift_count == 4'b0)) begin
                shift_count <= {1'b1, shift_count[2:0]};
            end else if (data == 0 && (shift_count == 4'b0)) begin
                shift_count <= {0, shift_count[2:1]};
            end else if (data == 1 && (shift_count == 4'b101)) begin
                shift_count <= {1'b1, shift_count[2:0]};
            end else if (data == 0 && (shift_count == 4'b101)) begin
                shift_count <= {1'b0, shift_count[2:1]};
            end
        end
        SHIFTING: begin
            if (shift_count == 4'd3) begin
                next_state = COUNTING;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

// Output logic
always_comb begin
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    case(state)
        IDLE: begin
        end
        SHIFTING: begin
            shift_ena = 1'b1;
        end
        COUNTING: begin
            counting = 1'b1;
        end
        DONE: begin
            done = 1'b1;
        end
    endcase
end

// Shift count increment
always_ff @(posedge clk) begin
    if (state == SHIFTING) begin
        shift_count <= shift_count + 1;
    end else if (state == IDLE && data == 1'b1) begin
        shift_count <= {1'b1, shift_count[2:0]};
    end else if (state == IDLE && data == 1'b0 && shift_count == 4'b110) begin
        shift_count <= {1'b0, shift_count[2:1]};
    end
end

endmodule