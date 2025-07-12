module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// One-hot state encoding for potentially better PPA
localparam [4:0] 
    A = 5'b00001,  // Initial state
    B = 5'b00010,  // Pulse f
    C = 5'b00100,  // Monitor x for 1-0-1
    D = 5'b01000,  // Monitor y with timeout
    E = 5'b10000;  // Final state

reg [4:0] state;
reg [1:0] x_history;  // Stores last 2 x values for sequence detection
reg timeout;          // Timeout flag

// State transitions and output logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 1'b0;
        g <= 1'b0;
        x_history <= 2'b00;
        timeout <= 1'b0;
    end
    else begin
        // Update x history shift register
        x_history <= {x_history[0], x};
        
        // Default outputs
        f <= 1'b0;
        
        case (state)
            A: begin
                // Stay in A until resetn is deasserted
                state <= B;
                g <= 1'b0;
            end
            
            B: begin
                // Pulse f for one cycle
                f <= 1'b1;
                state <= C;
                g <= 1'b0;
            end
            
            C: begin
                // Check for 1-0-1 sequence (current x is LSB)
                if (x_history == 2'b01 && x == 1'b1) begin
                    g <= 1'b1;
                    state <= D;
                    timeout <= 1'b0;
                end
                else begin
                    g <= 1'b0;
                end
            end
            
            D: begin
                g <= 1'b1;
                
                if (y) begin
                    state <= E;
                end
                else if (timeout) begin
                    g <= 1'b0;
                    state <= E;
                end
                else begin
                    timeout <= 1'b1;  // Set after first cycle
                end
            end
            
            E: begin
                // Maintain g output from previous state
                // No state change until reset
            end
        endcase
    end
end

endmodule