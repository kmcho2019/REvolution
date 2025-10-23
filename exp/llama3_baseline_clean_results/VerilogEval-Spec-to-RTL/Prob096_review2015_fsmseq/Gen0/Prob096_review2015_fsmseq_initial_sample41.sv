module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// Define states for the FSM
enum logic [1:0] {IDLE, SEEN1, SEEN11, SEEN110, SEEN1101} state, next_state;

// Initialize start_shifting
assign start_shifting = (state == SEEN1101);

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (state)
        IDLE: begin
            if (data) begin
                next_state = SEEN1;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN1: begin
            if (data) begin
                next_state = SEEN11;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN11: begin
            if (!data) begin
                next_state = SEEN110;
            end else begin
                next_state = SEEN11;
            end
        end
        SEEN110: begin
            if (data) begin
                next_state = SEEN1101;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN1101: begin
            next_state = SEEN1101; // stay in this state forever
        end
    endcase
end

endmodule