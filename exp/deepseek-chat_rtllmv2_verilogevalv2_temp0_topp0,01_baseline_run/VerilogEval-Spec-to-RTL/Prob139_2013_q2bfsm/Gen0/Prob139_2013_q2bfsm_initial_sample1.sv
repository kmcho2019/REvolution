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
        A = 3'b000,  // Initial state (reset)
        B = 3'b001,  // f=1 state
        C = 3'b010,  // Waiting for 1-0-1 pattern
        D = 3'b011,  // g=1, waiting for y=1
        E = 3'b100,  // g=1 permanently
        F = 3'b101   // g=0 permanently
    } state_t;

    state_t current_state, next_state;
    reg [1:0] x_history;  // Stores last 2 x values
    reg [1:0] y_timer;    // Counts cycles in state D

    // State transition and output logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            f <= 0;
            g <= 0;
            x_history <= 2'b00;
            y_timer <= 0;
        end else begin
            current_state <= next_state;
            
            // Update x history
            x_history <= {x_history[0], x};
            
            // Default outputs
            f <= 0;
            g <= 0;
            
            case (current_state)
                A: begin
                    next_state <= B;
                end
                
                B: begin
                    f <= 1;
                    next_state <= C;
                end
                
                C: begin
                    if (x_history == 2'b10 && x == 1'b1) begin  // Detected 1-0-1 pattern
                        next_state <= D;
                        y_timer <= 2'b10;  // Initialize timer (2 cycles)
                    end else begin
                        next_state <= C;
                    end
                end
                
                D: begin
                    g <= 1;
                    if (y) begin
                        next_state <= E;
                    end else if (y_timer == 0) begin
                        next_state <= F;
                    end else begin
                        y_timer <= y_timer - 1;
                        next_state <= D;
                    end
                end
                
                E: begin
                    g <= 1;
                    next_state <= E;
                end
                
                F: begin
                    g <= 0;
                    next_state <= F;
                end
                
                default: next_state <= A;
            endcase
        end
    end

endmodule