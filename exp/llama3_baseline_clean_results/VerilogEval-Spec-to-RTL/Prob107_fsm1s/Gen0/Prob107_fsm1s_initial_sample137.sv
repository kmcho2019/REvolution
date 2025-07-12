module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
typedef enum logic [0:0] {
    A,
    B
} state_t;

// Define the current state
state_t current_state;

// Define the output
assign out = (current_state == B) ? 1'b1 : 1'b0;

// State machine logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        case (current_state)
            A: begin
                if (!in) begin
                    current_state <= B;
                end
            end
            B: begin
                if (!in) begin
                    current_state <= A;
                end
            end
        endcase
    end
end

endmodule