module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // One-hot phase tracking (phase0, phase1, phase2)
    reg [2:0] phase = 3'b001;

    // 3-bit shift register for w history (only updated in state B)
    reg [2:0] w_history;

    // Combinational logic
    wire state_B = (state == B);
    wire phase_wrap = phase[0];  // phase==3'b001 (phase0)
    wire [2:0] next_phase = reset ? 3'b001 : 
                          state_B ? {phase[1:0], phase[2]} : 
                          3'b001;

    // Shift register only updates in state B
    wire [2:0] next_w_history = reset ? 3'b000 : 
                              state_B ? {w_history[1:0], w} : 
                              3'b000;

    // Pattern matching for exactly two 1's (011, 101, 110)
    wire popcount_2 = (w_history == 3'b011) | 
                     (w_history == 3'b101) | 
                     (w_history == 3'b110);

    // Output logic (only evaluated at phase wrap)
    assign z = state_B & phase_wrap & popcount_2;

    // Sequential update
    always @(posedge clk) begin
        state <= reset ? A : (state == A) ? (s ? B : A) : B;
        phase <= next_phase;
        if (state_B) w_history <= next_w_history;
    end

endmodule