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
        A = 3'b000,  // Reset state
        B = 3'b001,  // Initial state after reset (f=1)
        C = 3'b010,  // Monitoring x for 1-0-1 pattern
        D = 3'b011,  // g=1, monitoring y
        E = 3'b100,  // g=1 permanently
        F = 3'b101   // g=0 permanently
    } state_t;

    state_t current_state, next_state;
    reg [2:0] x_history;  // Shift register for last 3 x values
    reg [1:0] y_timeout;  // Counter for y monitoring

    // State transition and output logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            f <= 0;
            g <= 0;
            x_history <= 3'b000;
            y_timeout <= 2'b00;
        end else begin
            current_state <= next_state;
            
            // Update x history shift register
            x_history <= {x_history[1:0], x};
            
            // State-specific logic
            case (current_state)
                A: begin
                    f <= 0;
                    g <= 0;
                    x_history <= 3'b000;
                    y_timeout <= 2'b00;
                end
                
                B: begin
                    f <= 1;  // Set f=1 for one cycle
                end
                
                C: begin
                    f <= 0;
                    if (x_history == 3'b101) begin
                        g <= 1;
                    end
                end
                
                D: begin
                    if (y) begin
                        y_timeout <= 2'b00;
                    end else begin
                        y_timeout <= y_timeout + 1;
                    end
                end
                
                E: begin
                    g <= 1;
                end
                
                F: begin
                    g <= 0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = resetn ? B : A;
            B: next_state = C;
            C: next_state = (x_history == 3'b101) ? D : C;
            D: begin
                if (y) begin
                    next_state = E;
                end else if (y_timeout == 2'b10) begin
                    next_state = F;
                end else begin
                    next_state = D;
                end
            end
            E: next_state = E;
            F: next_state = F;
            default: next_state = A;
        endcase
    end

endmodule