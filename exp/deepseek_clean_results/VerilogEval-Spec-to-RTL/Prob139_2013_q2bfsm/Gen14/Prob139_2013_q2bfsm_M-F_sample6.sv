module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

localparam A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7;
reg [2:0] state;
reg [2:0] x_history;  // Tracks last three x values
reg [1:0] timeout;    // 2-bit timeout counter for y

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_history <= 3'b000;
        timeout <= 2'b00;
    end else begin
        // Shift register for x history
        x_history <= {x_history[1:0], x};
        
        case (state)
            A: state <= B;  // Move to initial pulse state
            
            B: state <= C;  // After initial pulse, start monitoring x
            
            C: if (x) state <= D;  // First 1 detected
            
            D: if (!x) state <= E;  // 0 detected after 1
                else state <= C;    // Stay if we get another 1
                
            E: if (x) state <= F;   // Second 1 completes 1-0-1
                else state <= C;    // Reset sequence if we get another 0
                
            F: begin
                if (y) state <= G;  // y=1 within timeout
                else if (timeout == 2'b01) state <= H;  // Timeout expired
                timeout <= timeout + 1;  // Increment timeout counter
            end
            
            G, H: ;  // Permanent states until reset
        endcase
    end
end

assign f = (state == B);
assign g = (state == F) || (state == G);

endmodule