module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding: 2 bits for state
    localparam IDLE = 2'b00;
    localparam GRANTED = 2'b01;
    reg [1:0] state, next_state;
    
    // Priority pointer (rotates to prevent starvation)
    reg [1:0] priority_ptr;
    
    // Current grantee tracking
    reg [1:0] current_grant;
    
    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= IDLE;
            priority_ptr <= 2'b00;  // Start with highest priority to r0
        end else begin
            state <= next_state;
            // Update priority pointer only when returning to idle
            if (state == GRANTED && next_state == IDLE)
                priority_ptr <= priority_ptr + 1;
        end
    end
    
    // Next state and grant logic
    always @(*) begin
        next_state = state;
        current_grant = 2'b11;  // Default to invalid
        
        case (state)
            IDLE: begin
                // Rotating priority selection
                if (r[priority_ptr]) begin
                    next_state = GRANTED;
                    current_grant = priority_ptr;
                end else if (r[(priority_ptr+1)%3]) begin
                    next_state = GRANTED;
                    current_grant = (priority_ptr+1)%3;
                end else if (r[(priority_ptr+2)%3]) begin
                    next_state = GRANTED;
                    current_grant = (priority_ptr+2)%3;
                end
            end
            GRANTED: begin
                // Continue grant if request persists
                if (!r[current_grant])
                    next_state = IDLE;
                else
                    current_grant = current_grant;
            end
        endcase
    end
    
    // Output decoder
    assign g = (state == GRANTED) ? (1 << current_grant) : 3'b000;
    
endmodule