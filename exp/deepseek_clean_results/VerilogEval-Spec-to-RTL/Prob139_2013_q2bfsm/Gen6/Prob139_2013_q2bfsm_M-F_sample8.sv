module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam RESET   = 2'd0;
localparam ACTIVE  = 2'd1;
localparam LOCKED  = 2'd2;

reg [1:0] state, next_state;
reg [2:0] x_shift;  // Shift register for x sequence
reg [1:0] timeout_counter;
reg resetn_prev;

always @(posedge clk) begin
    resetn_prev <= resetn;
end

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_shift <= 3'b0;
        timeout_counter <= 0;
    end
    else begin
        state <= next_state;
        x_shift <= {x_shift[1:0], x};  // Shift in new x value
        
        // Default outputs
        f <= 0;
        
        case (state)
            RESET: begin
                if (resetn && !resetn_prev) begin
                    f <= 1;  // Pulse f when reset is deasserted
                    next_state <= ACTIVE;
                end
                else begin
                    next_state <= RESET;
                end
            end
            
            ACTIVE: begin
                // Check for 1-0-1 pattern
                if (x_shift == 3'b101) begin
                    g <= 1;
                    timeout_counter <= 0;
                    next_state <= LOCKED;
                end
                else begin
                    next_state <= ACTIVE;
                end
            end
            
            LOCKED: begin
                if (timeout_counter < 2'd2) begin
                    if (y) begin
                        // y=1 detected - keep g=1 permanently
                        timeout_counter <= 2'd2;
                    end
                    else begin
                        timeout_counter <= timeout_counter + 1;
                        if (timeout_counter == 2'd1) begin
                            // Timeout reached - set g=0 permanently
                            g <= 0;
                        end
                    end
                end
                next_state <= LOCKED;
            end
        endcase
    end
end

endmodule