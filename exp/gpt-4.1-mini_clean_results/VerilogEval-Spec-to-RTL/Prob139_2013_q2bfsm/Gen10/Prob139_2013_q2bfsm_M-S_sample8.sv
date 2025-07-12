module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    typedef enum logic [2:0] {
        A = 3'd0, // Reset state
        B = 3'd1, // Assert f=1 for one cycle
        C = 3'd2, // Shift x and detect pattern 101
        D = 3'd3, // g=1, monitor y for 2 cycles
        E = 3'd4, // g=1 permanently (y=1 detected)
        F = 3'd5  // g=0 permanently (y=1 not detected)
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;     // shift register to track last 3 x inputs
    reg [1:0] y_count;     // counts cycles monitoring y

    // Sequential logic: state, shift register, y_count, outputs
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state <= next_state;

            case (next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end
                B: begin
                    f <= 1'b1;   // f asserted for one cycle
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end
                C: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    // Shift in new x
                    x_shift <= {x_shift[1:0], x};
                    y_count <= 2'd0;
                end
                D: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    x_shift <= x_shift; // hold
                    if (y_count < 2'd2)
                        y_count <= y_count + 1'b1;
                    else
                        y_count <= y_count;
                end
                E: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    x_shift <= x_shift;
                    y_count <= y_count;
                end
                F: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= x_shift;
                    y_count <= y_count;
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // After asserting f=1 one cycle, move to C to watch x inputs
                next_state = C;
            end
            C: begin
                // Wait until last 3 x inputs == 3'b101
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                // Monitor y for up to 2 cycles
                if (y == 1'b1)
                    next_state = E;  // y=1 detected
                else if (y_count >= 2'd2)
                    next_state = F;  // timeout, y=1 not detected
                else
                    next_state = D;  // keep monitoring
            end
            E: begin
                // stay with g=1 permanently
                next_state = E;
            end
            F: begin
                // stay with g=0 permanently
                next_state = F;
            end
            default: next_state = A;
        endcase
    end

endmodule