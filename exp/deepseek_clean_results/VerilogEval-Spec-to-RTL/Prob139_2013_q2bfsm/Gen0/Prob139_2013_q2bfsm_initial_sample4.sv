module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Define states
    typedef enum logic [2:0] {
        A,  // Initial/reset state
        B,  // Pulse f=1
        C,  // Wait for first 1 in x sequence
        D,  // Wait for 0 in x sequence
        E,  // Wait for second 1 in x sequence
        F,  // Wait for y=1 (with timeout)
        G   // Permanent g=0 state
    } state_t;

    state_t current_state, next_state;
    reg [1:0] timeout_counter;

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            timeout_counter <= 2'b00;
        end else begin
            current_state <= next_state;
            
            // Decrement timeout counter in state F
            if (current_state == F) begin
                timeout_counter <= timeout_counter - 1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = resetn ? B : A;
            B: next_state = C;
            C: next_state = x ? D : C;
            D: next_state = x ? C : E;
            E: next_state = x ? F : C;
            F: begin
                if (y) begin
                    next_state = F;  // Stay in F permanently
                end else if (timeout_counter == 0) begin
                    next_state = G;
                end else begin
                    next_state = F;
                end
            end
            G: next_state = G;
            default: next_state = A;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 0;
            g <= 0;
            timeout_counter <= 2'b10;  // Initialize timeout to 2 cycles
        end else begin
            // Default outputs
            f <= 0;
            g <= 0;

            case (current_state)
                B: f <= 1;
                F: begin
                    g <= 1;
                    if (next_state == F && y) begin
                        timeout_counter <= 2'b10;  // Reset counter if y=1 seen
                    end
                end
                G: g <= 0;
                default: ;  // Other states maintain default outputs
            endcase
        end
    end

endmodule