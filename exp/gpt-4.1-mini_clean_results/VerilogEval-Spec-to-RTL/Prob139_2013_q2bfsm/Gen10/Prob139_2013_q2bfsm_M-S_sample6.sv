module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam [2:0]
        A = 3'd0,  // Reset state, wait for reset release
        B = 3'd1,  // Assert f=1 for one cycle after reset release
        C = 3'd2,  // Shift x, detect pattern 101
        D = 3'd3,  // g=1, monitor y up to 2 cycles
        E = 3'd4,  // g=1 forever (y=1 detected)
        F = 3'd5;  // g=0 forever (timeout on y)

    reg [2:0] state, next_state;
    reg [2:0] pattern_reg;  // shift register for last 3 x inputs
    reg [1:0] y_timer;      // counts up to 2 cycles monitoring y

    always @(posedge clk) begin
        if (!resetn) begin
            state       <= A;
            f           <= 1'b0;
            g           <= 1'b0;
            pattern_reg <= 3'b000;
            y_timer     <= 2'b00;
        end else begin
            state <= next_state;
            case (next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    pattern_reg <= 3'b000;
                    y_timer <= 2'b00;
                end
                B: begin
                    f <= 1'b1;  // assert f for one cycle
                    g <= 1'b0;
                    // pattern_reg unchanged here
                    y_timer <= 2'b00;
                end
                C: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    // shift in x
                    pattern_reg <= {pattern_reg[1:0], x};
                    y_timer <= 2'b00;
                end
                D: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    // pattern_reg unchanged during monitoring y
                    // increment timer
                    if (y_timer < 2'd2)
                        y_timer <= y_timer + 1'b1;
                    else
                        y_timer <= y_timer;
                end
                E: begin
                    f <= 1'b0;
                    g <= 1'b1;  // hold g=1 permanently
                    // pattern_reg and y_timer hold their values
                end
                F: begin
                    f <= 1'b0;
                    g <= 1'b0;  // hold g=0 permanently
                    // pattern_reg and y_timer hold their values
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    pattern_reg <= 3'b000;
                    y_timer <= 2'b00;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                if (resetn)
                    next_state = B; // move to f pulse after reset released
                else
                    next_state = A;
            end
            B: begin
                next_state = C; // after one cycle f=1 pulse, go to pattern detect
            end
            C: begin
                // If last 3 x inputs are 101, go to monitor y
                if (pattern_reg == 3'b101)
                    next_state = D;
                else
                    next_state = C; // keep shifting in x
            end
            D: begin
                if (y == 1'b1)
                    next_state = E; // y detected, stay g=1 forever
                else if (y_timer >= 2'd2)
                    next_state = F; // timeout without y=1, set g=0 forever
                else
                    next_state = D; // keep monitoring y
            end
            E: begin
                // stay forever until reset
                next_state = E;
            end
            F: begin
                // stay forever until reset
                next_state = F;
            end
            default: next_state = A;
        endcase
    end

endmodule