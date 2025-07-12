module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
enum logic [1:0] {
    IDLE,
    SEQ1,
    SEQ2
} state, next_state;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Reset the state machine on asynchronous reset
        state <= IDLE;
    end else begin
        // Update the state
        state <= next_state;
    end
end

// Combinational logic to determine the next state
always_comb begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = SEQ1;
            end else begin
                next_state = IDLE;
            end
        end
        SEQ1: begin
            if (!x) begin
                next_state = SEQ2;
            end else begin
                next_state = SEQ1;
            end
        end
        SEQ2: begin
            if (x) begin
                next_state = IDLE;
            end else begin
                next_state = SEQ1;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Output logic: Assert z when the second '1' in the sequence is detected
assign z = (state == SEQ2) && x;

endmodule