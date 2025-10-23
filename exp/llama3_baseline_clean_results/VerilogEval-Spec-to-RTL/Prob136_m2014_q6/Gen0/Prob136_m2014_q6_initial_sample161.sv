module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as an enum
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_type;

// Initialize the current state
state_type current_state, next_state;

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    case (current_state)
        A: begin
            if (~w) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (~w) begin
                next_state = C;
            end else begin
                next_state = D;
            end
        end
        C: begin
            if (~w) begin
                next_state = E;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if (~w) begin
                next_state = F;
            end else begin
                next_state = A;
            end
        end
        E: begin
            if (~w) begin
                next_state = E;
            end else begin
                next_state = D;
            end
        end
        F: begin
            if (~w) begin
                next_state = C;
            end else begin
                next_state = D;
            end
        end
    endcase

    // Output z is determined by the current state
    case (current_state)
        E, F: z = 1;
        default: z = 0;
    endcase
end

endmodule