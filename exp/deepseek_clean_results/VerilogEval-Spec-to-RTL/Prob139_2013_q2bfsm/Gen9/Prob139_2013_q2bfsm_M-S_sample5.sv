module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
typedef enum logic [1:0] {
    A,  // Initial state (reset)
    B,  // Sets f=1 for one cycle
    C,  // Monitoring x and y
    D   // Final state
} state_t;

state_t state;

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            A: begin
                state <= B;
                f <= 1;
            end
            
            B: begin
                state <= C;
                f <= 0;
            end
            
            C: begin
                // Check for 1-0-1 sequence
                if (x) begin
                    state <= C1;
                end
            end
            
            C1: begin
                if (!x) begin
                    state <= C2;
                end else begin
                    state <= C;  // Reset sequence if not 1-0-1
                end
            end
            
            C2: begin
                if (x) begin
                    // Sequence detected, now monitor y
                    state <= Cy;
                    g <= 1;
                    y_counter <= 0;
                end else begin
                    state <= C;  // Reset sequence
                end
            end
            
            Cy: begin
                if (y) begin
                    state <= D;  // Keep g=1 permanently
                end else if (y_counter == 1) begin
                    state <= D;
                    g <= 0;      // Set g=0 permanently
                end else begin
                    y_counter <= y_counter + 1;
                end
            end
            
            D: begin
                // Stay in final state until reset
            end
        endcase
    end
end

endmodule