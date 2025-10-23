module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

localparam A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, F1 = 6, G = 7, H = 8;
reg [3:0] state;

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        case (state)
            A: state <= B;  // Initial state transition
            
            B: state <= C;  // After initial pulse
            
            C: if (x) state <= D;  // First 1 detected
            
            D: if (!x) state <= E;  // 0 detected after 1
                else state <= C;     // Stay if another 1
                
            E: if (x) state <= F;   // Second 1 completes 1-0-1
                else state <= C;    // Reset sequence if another 0
                
            F: begin
                if (y) state <= G;  // y=1 in first cycle
                else state <= F1;    // Move to second monitoring cycle
            end
            
            F1: begin
                if (y) state <= G;  // y=1 in second cycle
                else state <= H;   // Timeout - no y=1 detected
            end
            
            G, H: ;  // Permanent states until reset
        endcase
    end
end

assign f = (state == B);
assign g = (state == F) || (state == F1) || (state == G);

endmodule