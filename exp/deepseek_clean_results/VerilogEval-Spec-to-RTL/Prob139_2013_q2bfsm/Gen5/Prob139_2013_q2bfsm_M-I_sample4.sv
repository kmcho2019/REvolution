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
reg [1:0] x_shift;  // Shift register for x sequence
reg timeout;        // Timeout flag

// State transitions and outputs
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_shift <= 2'b00;
        timeout <= 1'b0;
        f <= 1'b0;
        g <= 1'b0;
    end
    else begin
        // Default outputs
        f <= 1'b0;
        g <= 1'b0;

        // Shift register for x sequence detection
        x_shift <= {x_shift[0], x};

        case (state)
            A: begin
                state <= B;
            end
            B: begin
                f <= 1'b1;  // Pulse f for one cycle
                state <= C;
            end
            C: begin
                if (x_shift == 2'b10 && x) begin  // Detected 1-0-1
                    g <= 1'b1;
                    state <= D;
                end
            end
            D: begin
                g <= 1'b1;
                if (y) begin
                    state <= E;  // Permanent g=1
                end
                else if (timeout) begin
                    state <= E;  // Permanent g=0
                end
                else begin
                    timeout <= 1'b1;  // Set timeout after 1 cycle
                end
            end
            E: begin
                g <= y;  // Maintain last y value
            end
        endcase
    end
end

endmodule