module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam [2:0]
        A = 3'd0,  // reset state, f=0, g=0
        B = 3'd1,  // f=1 one cycle after reset
        C = 3'd2,  // monitor x pattern 1,0,1
        D = 3'd3,  // g=1 pulse after pattern detected
        E = 3'd4,  // monitor y for up to 2 cycles with g=1
        F = 3'd5,  // g=1 permanent
        G = 3'd6;  // g=0 permanent

    reg [2:0] state, next_state;
    reg [2:0] x_shift, next_x_shift;
    reg [1:0] y_count, next_y_count;

    // Sequential logic: state, x_shift, y_count update
    always @(posedge clk) begin
        if (!resetn) begin
            state    <= A;
            x_shift  <= 3'b000;
            y_count  <= 2'b00;
            f        <= 1'b0;
            g        <= 1'b0;
        end else begin
            state    <= next_state;
            x_shift  <= next_x_shift;
            y_count  <= next_y_count;
            // Outputs assigned below in always block
        end
    end

    // Combinational next state and control logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_x_shift = x_shift;
        next_y_count = y_count;

        // Default outputs
        // f and g are assigned synchronously, but here we compute next outputs for clarity
        // We'll assign outputs in sequential block after state update for clarity
        case(state)
            A: begin
                // Stay in A as long as resetn=0, then go to B
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
                next_x_shift = 3'b000;
                next_y_count = 2'b00;
            end
            B: begin
                // f=1 for one cycle, then move to monitor pattern
                next_state = C;
                next_x_shift = {x_shift[1:0], x};
                next_y_count = 2'b00;
            end
            C: begin
                // Shift x every cycle
                next_x_shift = {x_shift[1:0], x};
                next_y_count = 2'b00;
                if (next_x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                // One cycle g=1 pulse, then move to y monitoring
                next_state = E;
                next_x_shift = 3'b000;
                next_y_count = 2'b00;
            end
            E: begin
                // Maintain g=1, monitor y up to 2 cycles
                next_x_shift = 3'b000;
                if (y == 1'b1) begin
                    next_state = F;  // y=1 detected, g=1 permanent
                    next_y_count = 2'b00;
                end else if (y_count == 2'd1) begin
                    // 2 cycles elapsed without y=1
                    next_state = G;  // g=0 permanent
                    next_y_count = 2'b00;
                end else begin
                    next_state = E;
                    next_y_count = y_count + 1'b1;
                end
            end
            F: begin
                // g=1 permanent until reset
                next_state = F;
                next_x_shift = 3'b000;
                next_y_count = 2'b00;
            end
            G: begin
                // g=0 permanent until reset
                next_state = G;
                next_x_shift = 3'b000;
                next_y_count = 2'b00;
            end
            default: begin
                next_state = A;
                next_x_shift = 3'b000;
                next_y_count = 2'b00;
            end
        endcase
    end

    // Assign outputs based on state, synchronously updated
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            case(state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                B: begin
                    f <= 1'b1;   // one cycle pulse after reset release
                    g <= 1'b0;
                end
                C: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                D: begin
                    f <= 1'b0;
                    g <= 1'b1;   // one cycle pulse after pattern detected
                end
                E: begin
                    f <= 1'b0;
                    g <= 1'b1;   // monitor y with g=1
                end
                F: begin
                    f <= 1'b0;
                    g <= 1'b1;   // g=1 permanent
                end
                G: begin
                    f <= 1'b0;
                    g <= 1'b0;   // g=0 permanent
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

endmodule