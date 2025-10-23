module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0, // reset state
        B = 3'd1, // pulse f=1 once after reset
        C = 3'd2, // monitor x pattern 1-0-1
        D = 3'd3, // pulse g=1 once after pattern detected
        E = 3'd4, // hold g=1 and monitor y for 2 cycles
        F = 3'd5, // permanent g=1
        G = 3'd6  // permanent g=0
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] x_shift;    // shift register for last 3 x inputs
    reg [1:0] y_count;    // count cycles in state E

    // Sequential logic: state, registers and outputs
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state <= next_state;

            // Shift in x every cycle
            x_shift <= {x_shift[1:0], x};

            // y_count logic: valid only in E
            if (state == E) begin
                if (y == 1'b1) begin
                    y_count <= 2'd0;
                end else begin
                    y_count <= y_count + 1'b1;
                end
            end else begin
                y_count <= 2'd0;
            end

            // Outputs depend on current state
            case (state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                B: begin
                    f <= 1'b1; // one cycle pulse
                    g <= 1'b0;
                end
                C: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                D: begin
                    f <= 1'b0;
                    g <= 1'b1; // one cycle pulse
                end
                E: begin
                    f <= 1'b0;
                    g <= 1'b1; // hold g=1 and monitor y
                end
                F: begin
                    f <= 1'b0;
                    g <= 1'b1; // permanent g=1
                end
                G: begin
                    f <= 1'b0;
                    g <= 1'b0; // permanent g=0
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            A: begin
                // On release of reset, move to B
                next_state = B;
            end
            B: begin
                // After pulse f=1, move to pattern monitor
                next_state = C;
            end
            C: begin
                // Detect x pattern 1,0,1 in last 3 cycles
                if (x_shift == 3'b101) begin
                    next_state = D;
                end else begin
                    next_state = C;
                end
            end
            D: begin
                // Pulse g=1 for one cycle, then move to y monitoring
                next_state = E;
            end
            E: begin
                if (y == 1'b1) begin
                    // y=1 detected within 2 cycles
                    next_state = F;
                end else if (y_count == 2'd2) begin
                    // y not detected within 2 cycles
                    next_state = G;
                end else begin
                    next_state = E;
                end
            end
            F: begin
                // Permanent g=1 hold
                next_state = F;
            end
            G: begin
                // Permanent g=0 hold
                next_state = G;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

endmodule