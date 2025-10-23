module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as an enumeration
enum logic [2:0] {
    A, B, C, D, E, F
} state, next_state;

// Initialize the state machine
initial state = A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Calculate the next state based on the current state and input w
always @(*) begin
    case (state)
        A: begin
            if (w) begin
                next_state <= A;
            end else begin
                next_state <= B;
            end
        end
        B: begin
            if (w) begin
                next_state <= D;
            end else begin
                next_state <= C;
            end
        end
        C: begin
            if (w) begin
                next_state <= D;
            end else begin
                next_state <= E;
            end
        end
        D: begin
            if (w) begin
                next_state <= A;
            end else begin
                next_state <= F;
            end
        end
        E: begin
            if (w) begin
                next_state <= D;
            end else begin
                next_state <= E;
            end
        end
        F: begin
            if (w) begin
                next_state <= D;
            end else begin
                next_state <= C;
            end
        end
    endcase
end

// Calculate the output z based on the current state
always @(*) begin
    case (state)
        A, B, C, D: z <= 0;
        E, F: z <= 1;
    endcase
end

endmodule