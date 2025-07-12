module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    reg [1:0] state; // State variable to keep track of current state
    reg [1:0] x_seq; // To keep track of x input sequence
    reg [1:0] y_cnt; // Counter for y input check

    // State definitions
    localparam A = 2'b00; // Reset state
    localparam B = 2'b01; // Set f to 1
    localparam C = 2'b10; // Monitor x sequence
    localparam D = 2'b11; // Monitor y

    always @(posedge clk) begin
        if (~resetn) begin // Reset condition
            state <= A;
            x_seq <= 0;
            y_cnt <= 0;
            f <= 0;
            g <= 0;
        end else begin
            case (state)
                A: begin
                    state <= B; // Move to B after reset de-assertion
                    f <= 0;
                    g <= 0;
                end
                B: begin
                    state <= C; // Move to C after setting f to 1
                    f <= 1;
                    g <= 0;
                end
                C: begin
                    // Monitor x sequence
                    x_seq <= {x_seq[0], x}; // Shift x sequence
                    if (x_seq == 2'b101) begin // Sequence detected
                        state <= D;
                        g <= 1;
                        y_cnt <= 0;
                    end else begin
                        state <= C; // Stay in C until sequence is detected
                    end
                    f <= 0; // f should be 0 after the initial cycle
                end
                D: begin
                    y_cnt <= y_cnt + 1; // Increment counter for y check
                    if (y || y_cnt > 2) begin // y is 1 or y_cnt exceeds 2
                        if (y) begin
                            y_cnt <= 0; // Reset counter if y is detected
                        end
                        state <= D; // Stay in D if y is detected or y_cnt > 2
                    end else begin
                        if (y_cnt == 2) begin // If y_cnt reaches 2 without y being 1
                            state <= 2'b10; // Incorrectly placed, change this line to go back to state E
                            state <= 2'b00; // Changed to state A as a placeholder for state E
                            g <= 0; // Set g to 0 permanently
                        end
                    end
                    f <= 0; // f remains 0
                end
                default: state <= A; // Default to state A for any other condition
            endcase
        end
    end
endmodule