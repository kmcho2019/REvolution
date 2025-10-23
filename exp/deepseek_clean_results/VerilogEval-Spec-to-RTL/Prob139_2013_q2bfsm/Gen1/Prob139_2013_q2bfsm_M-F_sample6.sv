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
        A = 3'b000,  // Initial/reset state
        B = 3'b001,  // Pulse f=1
        C = 3'b010,  // Wait for first 1 in x sequence
        D = 3'b011,  // Wait for 0 in x sequence
        E = 3'b100,  // Wait for second 1 in x sequence
        F = 3'b101,  // Wait for y=1 (with timeout)
        G = 3'b110   // Permanent g=0 state
    } state_t;

    state_t current_state, next_state;
    reg [1:0] timeout_counter;

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            timeout_counter <= 2'b10;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            current_state <= next_state;
            
            // Decrement timeout counter in state F
            if (current_state == F && !y) begin
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
                end else if (timeout_counter == 2'b00) begin
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
    always @(*) begin
        f = 1'b0;
        g = 1'b0;
        
        case (current_state)
            B: f = 1'b1;
            F: g = 1'b1;
            G: g = 1'b0;
            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule