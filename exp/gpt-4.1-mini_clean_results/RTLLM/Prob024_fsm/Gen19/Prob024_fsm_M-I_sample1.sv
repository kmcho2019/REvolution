module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // One-hot state encoding for the sequence "10011"
    // S0: no match yet      (000001)
    // S1: matched '1'       (000010)
    // S2: matched '10'      (000100)
    // S3: matched '100'     (001000)
    // S4: matched '1001'    (010000)
    // S5: unused (100000)   - reserved for safe reset state (not used)

    localparam [5:0]
        S0 = 6'b000001,
        S1 = 6'b000010,
        S2 = 6'b000100,
        S3 = 6'b001000,
        S4 = 6'b010000;

    reg [5:0] state, next_state;
    reg clk_en; // clock enable to reduce unnecessary toggling

    // Generate clock enable: FSM transitions only matter when input changes or leads to state change
    // For Mealy FSM, input-dependent transitions happen every cycle, so we keep clk_en always 1.
    // However, if desired, can implement input change detection for power gating; skipped here for simplicity.
    always @(*) begin
        clk_en = 1'b1; 
    end

    // Sequential logic with synchronous reset and clock enable
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else if (clk_en) begin
            state <= next_state;

            // Mealy output: MATCH is 1 when transitioning from S4 on IN=1 input
            // That means MATCH is asserted when current state is S4 and input IN is 1
            MATCH <= (state == S4) && IN;
        end
    end

    // Next-state combinational logic using if-else for balanced path
    always @(*) begin
        case (state)
            S0: if (IN)       next_state = S1;
                else          next_state = S0;

            S1: if (!IN)      next_state = S2;
                else          next_state = S1;

            S2: if (!IN)      next_state = S3;
                else          next_state = S1; // overlap: restart from S1 on input=1

            S3: if (IN)       next_state = S4;
                else          next_state = S0;

            S4: if (IN)       next_state = S1; // overlap: after match restart pattern detection
                else          next_state = S2;

            default:          next_state = S0;
        endcase
    end

endmodule