module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding using localparam for clarity
    localparam [3:0]
        A  = 4'd0,  // reset state, f=0, g=0
        B  = 4'd1,  // pulse f=1 once after reset release
        C0 = 4'd2,  // pattern detection start (no bits matched)
        C1 = 4'd3,  // pattern detected first bit '1'
        C2 = 4'd4,  // pattern detected bits '10'
        D  = 4'd5,  // pulse g=1 once after pattern detected
        E1 = 4'd6,  // monitor y cycle 1, g=1
        E2 = 4'd7,  // monitor y cycle 2, g=1
        F  = 4'd8,  // g=1 permanent
        G  = 4'd9;  // g=0 permanent

    reg [3:0] state, next_state;

    // State register with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;  // default hold
        case (state)
            A: begin
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // After pulsing f, start pattern detection
                next_state = C0;
            end
            // Pattern detection with sliding window states
            C0: begin
                // Waiting for first bit '1'
                if (x == 1'b1)
                    next_state = C1;
                else
                    next_state = C0;
            end
            C1: begin
                // Matched first bit '1'
                if (x == 1'b0)
                    next_state = C2;    // second bit matched '0'
                else if (x == 1'b1)
                    next_state = C1;    // stay if still '1' (possible overlapping)
                else
                    next_state = C0;    // failback
            end
            C2: begin
                // Matched '10'
                if (x == 1'b1)
                    next_state = D;     // full pattern 101 detected
                else if (x == 1'b0)
                    next_state = C0;    // pattern broken, restart
                else
                    next_state = C0;
            end
            D: begin
                // Pulse g=1 once, then start y monitoring
                next_state = E1;
            end
            E1: begin
                // Monitor y cycle 1
                if (y == 1'b1)
                    next_state = F;  // y detected, hold g=1
                else
                    next_state = E2; // continue monitoring
            end
            E2: begin
                // Monitor y cycle 2
                if (y == 1'b1)
                    next_state = F;  // y detected, hold g=1
                else
                    next_state = G;  // y not detected in time, g=0 permanent
            end
            F: begin
                // Permanent g=1 state
                next_state = F;
            end
            G: begin
                // Permanent g=0 state
                next_state = G;
            end
            default: next_state = A;
        endcase
    end

    // Moore output logic, depend only on current state
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            case (state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                B: begin
                    f <= 1'b1;  // pulse f for one cycle
                    g <= 1'b0;
                end
                C0, C1, C2: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                D: begin
                    f <= 1'b0;
                    g <= 1'b1;  // pulse g for one cycle
                end
                E1, E2: begin
                    f <= 1'b0;
                    g <= 1'b1;  // hold g=1 while monitoring y
                end
                F: begin
                    f <= 1'b0;
                    g <= 1'b1;  // permanent g=1
                end
                G: begin
                    f <= 1'b0;
                    g <= 1'b0;  // permanent g=0
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

endmodule