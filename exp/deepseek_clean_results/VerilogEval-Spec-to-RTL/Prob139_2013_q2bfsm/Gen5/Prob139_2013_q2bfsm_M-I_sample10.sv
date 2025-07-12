module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
typedef enum logic [2:0] {
    A = 3'd0,  // Initial state
    B = 3'd1,  // Pulse f
    C = 3'd2,  // Monitor x for 1-0-1
    D = 3'd3,  // Monitor y with timeout
    E = 3'd4   // Final state
} state_t;

state_t state;
reg [2:0] x_history;  // Stores last 3 x values
reg [1:0] timeout;

// State transitions and output logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 1'b0;
        g <= 1'b0;
        x_history <= 3'b000;
        timeout <= 2'b00;
    end
    else begin
        // Update x history shift register
        x_history <= {x_history[1:0], x};
        
        // Default outputs
        f <= 1'b0;
        g <= 1'b0;

        case (state)
            A: begin
                state <= B;
            end
            
            B: begin
                f <= 1'b1;
                state <= C;
            end
            
            C: begin
                // Check for 1-0-1 sequence (MSB is oldest)
                if (x_history == 3'b101) begin
                    g <= 1'b1;
                    state <= D;
                end
            end
            
            D: begin
                g <= 1'b1;
                
                if (y) begin
                    state <= E;
                end
                else if (timeout == 2'b01) begin  // After 2 cycles
                    state <= E;
                end
                else begin
                    timeout <= timeout + 1;
                end
            end
            
            E: begin
                // Maintain g output from previous state
                g <= (state == D) ? 1'b1 : g;
            end
        endcase
    end
end

endmodule