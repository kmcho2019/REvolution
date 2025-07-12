module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Enumerate the states
enum logic [2:0] {
    STATE_A,
    STATE_B,
    STATE_C,
    STATE_D,
    STATE_E,
    STATE_F
} state, next_state;

// Counter for clock cycles in states C and D
reg [1:0] counter;

always @(*) begin
    // Initialize next_state to the current state
    next_state = state;
    
    // Default values for outputs
    f = 0;
    g = 0;
    
    case (state)
        STATE_A: begin
            // Stay in STATE_A if reset is asserted
            if (~resetn) begin
                next_state = STATE_A;
            end else begin
                // Move to STATE_B when reset is de-asserted
                next_state = STATE_B;
            end
        end
        
        STATE_B: begin
            // Set output f to 1 for one clock cycle
            f = 1;
            next_state = STATE_C;
        end
        
        STATE_C: begin
            // Monitor x input for sequence 1, 0, 1
            if (x == 1 && counter == 0) begin
                counter = counter + 1;
            end else if (x == 0 && counter == 1) begin
                counter = counter + 1;
            end else if (x == 1 && counter == 2) begin
                next_state = STATE_D;
                counter = 0;
            end else begin
                counter = 0;
            end
        end
        
        STATE_D: begin
            // Set output g to 1 and monitor y input
            g = 1;
            if (y == 1) begin
                next_state = STATE_E;
            end else if (counter == 2) begin
                next_state = STATE_F;
            end else begin
                counter = counter + 1;
            end
        end
        
        STATE_E: begin
            // Maintain g = 1 permanently
            g = 1;
        end
        
        STATE_F: begin
            // Set g = 0 permanently
        end
        
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= STATE_A;
        counter <= 0;
    end else begin
        state <= next_state;
    end
end

endmodule