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

typedef enum {Idle, Shift, Count, DoneWait} state_t;

state_t state, next_state;

// Sequential Logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
    end else begin
        state <= next_state;
    end
end

// Combinational Logic
always_comb begin
    case (state)
        Idle: begin
            if (data == 1'b1) begin
                next_state = Shift;
                shift_ena = 1'b1;
                counting = 1'b0;
                done = 1'b0;
            end else begin
                next_state = Idle;
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end
        end
        Shift: begin
            if (data == 1'b0) begin
                next_state = Count;
                shift_ena = 1'b0;
                counting = 1'b1;
                done = 1'b0;
            end else begin
                next_state = Shift;
                shift_ena = 1'b1;
                counting = 1'b0;
                done = 1'b0;
            end
        end
        Count: begin
            if (done_counting) begin
                next_state = DoneWait;
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b1;
            end else begin
                next_state = Count;
                shift_ena = 1'b0;
                counting = 1'b1;
                done = 1'b0;
            end
        end
        DoneWait: begin
            if (ack) begin
                next_state = Idle;
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end else begin
                next_state = DoneWait;
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b1;
            end
        end
        default: begin
            next_state = Idle;
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
    endcase
end

endmodule