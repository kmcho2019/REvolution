module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
typedef enum logic [0:0] {
    B,
    A
} state_type;

// Current state register
state_type current_state;

// Output logic
always_comb begin
    case (current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0; // default output if needed
    endcase
end

// State machine logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        case (current_state)
            B: begin
                if (!in) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            A: begin
                if (!in) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            default: current_state <= B; // default state if needed
        endcase
    end
end

endmodule