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

    // Phase tracking (0-2)
    reg [1:0] phase;

    // 3-bit shift register for w history
    reg [2:0] w_history;

    // Combinational next state
    wire next_state = reset ? A : (state == A) ? (s ? B : A) : B;

    // Combinational next phase (modulo-3 counter)
    wire [1:0] next_phase = reset ? 2'd0 : (state == B) ? (phase + 1'b1) % 3 : 2'd0;

    // Shift register update (only in state B)
    wire [2:0] next_w_history = reset ? 3'b000 : (state == B) ? {w_history[1:0], w} : 3'b000;

    // Popcount calculation (only when phase wraps)
    wire [1:0] popcount = w_history[0] + w_history[1] + w_history[2];

    // Output logic (evaluate at start of new window)
    assign z = (state == B) && (next_phase == 2'd0) && (popcount == 2'd2);

    // Sequential update
    always @(posedge clk) begin
        state <= next_state;
        phase <= next_phase;
        if (state == B || next_state == B) begin
            w_history <= next_w_history;
        end else begin
            w_history <= 3'b000;
        end
    end

endmodule