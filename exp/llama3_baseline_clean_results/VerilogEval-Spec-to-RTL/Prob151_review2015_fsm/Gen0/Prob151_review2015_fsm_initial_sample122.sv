module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

// Define the states
parameter IDLE = 4'b0000;
parameter SHIFT = 4'b0001;
parameter COUNT = 4'b0010;
parameter DONE_WAIT = 4'b0011;
parameter DONE = 4'b0100;

reg [3:0] current_state, next_state;
reg [3:0] shift_count;

always @(*) begin
    case(current_state)
        IDLE: begin
            if (data == 1'b1 && reset == 1'b0) begin
                // Check for the pattern 1101
                if (data == 1'b1) begin
                    next_state = IDLE;
                    shift_ena = 1'b0;
                    counting = 1'b0;
                    done = 1'b0;
                end else begin
                    next_state = IDLE;
                    shift_ena = 1'b0;
                    counting = 1'b0;
                    done = 1'b0;
                end
            end else if (reset == 1'b1) begin
                next_state = IDLE;
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end else begin
                next_state = IDLE;
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end
        end
        SHIFT: begin
            shift_ena = 1'b1;
            counting = 1'b0;
            done = 1'b0;
            if (shift_count == 4'b1000) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            shift_ena = 1'b0;
            counting = 1'b1;
            done = 1'b0;
            if (done_counting == 1'b1) begin
                next_state = DONE_WAIT;
            end else begin
                next_state = COUNT;
            end
        end
        DONE_WAIT: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b1;
            if (ack == 1'b1) begin
                next_state = IDLE;
            end else begin
                next_state = DONE_WAIT;
            end
        end
        DONE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b1;
            if (ack == 1'b1) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: begin
            next_state = IDLE;
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        current_state <= IDLE;
        shift_count <= 4'b0000;
    end else begin
        current_state <= next_state;
        if (current_state == SHIFT) begin
            shift_count <= shift_count + 1'b1;
        end else begin
            shift_count <= 4'b0000;
        end
    end
end

endmodule