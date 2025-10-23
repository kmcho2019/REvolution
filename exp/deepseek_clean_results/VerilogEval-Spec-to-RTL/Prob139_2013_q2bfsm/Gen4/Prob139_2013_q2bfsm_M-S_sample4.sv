module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // State encoding
    parameter A = 2'd0;  // Reset state
    parameter B = 2'd1;  // f pulse state
    parameter C = 2'd2;  // Pattern monitoring
    parameter D = 2'd3;  // Final state (g permanent)

    reg [1:0] state;
    reg [2:0] x_shift;   // Shift register for x pattern
    reg g_permanent;     // Permanent g value

    // State transition and pattern detection
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_shift <= 3'b000;
            g_permanent <= 1'b0;
        end else begin
            x_shift <= {x_shift[1:0], x};
            
            case (state)
                A: state <= B;
                B: state <= C;
                C: if (x_shift == 3'b101) begin
                    state <= D;
                    g_permanent <= 1'b1;  // Start with g=1
                end
                D: begin
                    if (g_permanent) begin
                        if (!y) begin
                            // After 2 cycles without y=1, set g=0 permanently
                            if (x_shift[1:0] == 2'b01) begin
                                g_permanent <= 1'b0;
                            end
                        end
                    end
                end
            endcase
        end
    end

    // Output logic
    assign f = (state == B);
    assign g = (state == D) && g_permanent;

endmodule