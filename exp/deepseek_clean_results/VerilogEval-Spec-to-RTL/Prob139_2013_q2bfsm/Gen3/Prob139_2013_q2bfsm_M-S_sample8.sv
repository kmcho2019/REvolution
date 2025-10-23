module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // State encoding
    parameter A = 2'd0;  // Initial state
    parameter B = 2'd1;  // f pulse state
    parameter C = 2'd2;  // Pattern monitoring
    parameter D = 2'd3;  // y monitoring (g=1)

    reg [1:0] state;
    reg [2:0] x_shift;   // Shift register for x pattern
    reg y_timeout;       // Flag for y monitoring timeout

    // State transition and pattern detection
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_shift <= 3'b000;
            y_timeout <= 1'b0;
        end else begin
            x_shift <= {x_shift[1:0], x};
            
            case (state)
                A: state <= B;
                B: state <= C;
                C: if (x_shift == 3'b101) state <= D;
                D: begin
                    if (y) begin
                        y_timeout <= 1'b0;  // Permanent g=1
                    end else if (!y_timeout) begin
                        y_timeout <= 1'b1;  // First timeout
                    end else begin
                        state <= C;         // Second timeout, return to monitoring
                    end
                end
            endcase
        end
    end

    // Output logic
    assign f = (state == B);
    assign g = (state == D) && !y_timeout;

endmodule