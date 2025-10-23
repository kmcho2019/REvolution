module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define states for the FSM
enum logic [2:0] {
    S_RESET,  // Reset state, behaves as if previous input was 0
    S_ZERO,   // State after a 0 is encountered
    S_ONE,    // State after a single 1 is encountered
    S_ONES2,  // State after two consecutive 1s are encountered
    S_ONES3,  // State after three consecutive 1s are encountered
    S_ONES4,  // State after four consecutive 1s are encountered
    S_ONES5,  // State after five consecutive 1s are encountered
    S_ONES6,  // State after six consecutive 1s are encountered
    S_FLAG    // State when a flag (01111110) is detected
} state, next_state;

// Outputs
logic disc_out;
logic flag_out;
logic err_out;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= S_RESET;
        disc_out <= 0;
        flag_out <= 0;
        err_out <= 0;
    end else begin
        state <= next_state;
        disc_out <= 0;
        flag_out <= 0;
        err_out <= 0;
        case (state)
            S_RESET: begin
                if (in) begin
                    next_state <= S_ONE;
                end else begin
                    next_state <= S_ZERO;
                end
            end
            S_ZERO: begin
                if (in) begin
                    next_state <= S_ONE;
                end else begin
                    next_state <= S_ZERO;
                end
            end
            S_ONE: begin
                if (in) begin
                    next_state <= S_ONES2;
                end else begin
                    next_state <= S_ZERO;
                end
            end
            S_ONES2: begin
                if (in) begin
                    next_state <= S_ONES3;
                end else begin
                    next_state <= S_ZERO;
                end
            end
            S_ONES3: begin
                if (in) begin
                    next_state <= S_ONES4;
                end else begin
                    next_state <= S_ZERO;
                end
            end
            S_ONES4: begin
                if (in) begin
                    next_state <= S_ONES5;
                end else begin
                    next_state <= S_ZERO;
                end
            end
            S_ONES5: begin
                if (in) begin
                    next_state <= S_ONES6;
                end else begin
                    disc_out <= 1; // discard the inserted 0
                    next_state <= S_ZERO;
                end
            end
            S_ONES6: begin
                if (in) begin
                    err_out <= 1; // error, 7 or more consecutive 1s
                    next_state <= S_ONES6;
                end else begin
                    flag_out <= 1; // flag detected
                    next_state <= S_ZERO;
                end
            end
            S_FLAG: begin
                next_state <= S_FLAG;
            end
        endcase
    end
end

// Combinational logic
assign disc = disc_out;
assign flag = flag_out;
assign err = err_out;

endmodule