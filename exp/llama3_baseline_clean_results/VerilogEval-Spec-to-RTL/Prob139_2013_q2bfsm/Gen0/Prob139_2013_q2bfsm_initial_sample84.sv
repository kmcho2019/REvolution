module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Enumerated type for states
enum logic [2:0] {
    A,  // Initial state
    B,  // Set f to 1
    C,  // Wait for x sequence
    D,  // Monitor y
    E   // g = 0
} state, next_state;

// Registers to store current state and sequence counter
reg [1:0] x_seq_counter;  // Counts x sequence
reg [1:0] y_wait_counter;  // Counts cycles waiting for y
reg seen_1;  // Flag to indicate if first '1' in sequence is seen

always @(*) begin
    // Default next state is current state
    next_state = state;
    
    case (state)
        A: begin
            if (~resetn) begin
                next_state = A;  // Stay in A if reset is asserted
            end else begin
                next_state = B;  // Move to B when reset is deasserted
            end
        end
        B: begin
            next_state = C;  // Move to C after setting f
        end
        C: begin
            if (x_seq_counter == 3'b111) begin  // If x sequence is seen
                next_state = D;  // Move to D
            end else begin
                next_state = C;  // Stay in C
            end
        end
        D: begin
            if (y_wait_counter == 2'b10 && ~y) begin  // If y not seen in 2 cycles
                next_state = E;  // Move to E
            end else if (y) begin
                next_state = D;  // Stay in D if y seen
            end else begin
                next_state = D;  // Stay in D
            end
        end
        E: begin
            next_state = E;  // Stay in E
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= A;  // Reset state to A on reset
        x_seq_counter <= 0;  // Reset x sequence counter
        y_wait_counter <= 0;  // Reset y wait counter
        seen_1 <= 0;  // Reset seen_1 flag
        f <= 0;  // Reset f
        g <= 0;  // Reset g
    end else begin
        state <= next_state;  // Update state
        
        case (state)
            B: begin
                f <= 1;  // Set f to 1
            end
            C: begin
                if (x == 1 && ~seen_1) begin  // First '1' in sequence
                    seen_1 <= 1;  // Set seen_1 flag
                    x_seq_counter <= 1;  // Increment x sequence counter
                end else if (x == 0 && seen_1) begin  // '0' after '1'
                    seen_1 <= 0;  // Reset seen_1 flag
                    x_seq_counter <= 2;  // Increment x sequence counter
                end else if (x == 1 && ~seen_1 && x_seq_counter == 2) begin  // Second '1'
                    x_seq_counter <= 3;  // Set x sequence counter to 3
                end
                f <= 0;  // Reset f
            end
            D: begin
                g <= 1;  // Set g to 1
                if (~y) begin  // If y not seen
                    y_wait_counter <= y_wait_counter + 1;  // Increment y wait counter
                end else begin
                    y_wait_counter <= 0;  // Reset y wait counter
                end
                f <= 0;  // Reset f
            end
            E: begin
                g <= 0;  // Set g to 0
                f <= 0;  // Reset f
            end
            default: begin
                f <= 0;  // Reset f
            end
        endcase
    end
end

endmodule