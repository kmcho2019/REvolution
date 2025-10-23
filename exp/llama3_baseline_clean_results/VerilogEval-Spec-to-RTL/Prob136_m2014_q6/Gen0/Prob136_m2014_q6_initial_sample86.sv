module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states of the state machine
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

// Declare the current state and next state variables
state_t current_state;
state_t next_state;

// Combinational logic block to determine the next state
always_comb begin
    case (current_state)
        A: begin
            if (w) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (w) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        C: begin
            if (w) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        D: begin
            if (w) begin
                next_state = A;
            end else begin
                next_state = F;
            end
        end
        E: begin
            if (w) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        F: begin
            if (w) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
    endcase
end

// Sequential logic block to update the current state
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Determine the output 'z' based on the current state
always_comb begin
    case (current_state)
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule