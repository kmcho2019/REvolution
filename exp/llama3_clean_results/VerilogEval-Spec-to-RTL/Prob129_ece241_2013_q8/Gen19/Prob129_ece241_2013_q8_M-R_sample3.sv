module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
typedef enum logic [1:0] {
    IDLE = 2'b00,
    PREFIX = 2'b01,
    MATCH = 2'b10
} state_t;

// Define the state register
state_t state;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Reset the state on asynchronous reset
        state <= IDLE;
    end else begin
        // State transitions
        case (state)
            IDLE: begin
                if (x) begin
                    state <= PREFIX;
                end
            end
            PREFIX: begin
                if (!x) begin
                    state <= MATCH;
                end else begin
                    state <= PREFIX;
                end
            end
            MATCH: begin
                if (x) begin
                    state <= IDLE; // Reset to IDLE after match
                end else begin
                    state <= PREFIX;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

// Output logic: Assert z when the state is MATCH and the current input is "1"
assign z = (state == MATCH) && x;

endmodule