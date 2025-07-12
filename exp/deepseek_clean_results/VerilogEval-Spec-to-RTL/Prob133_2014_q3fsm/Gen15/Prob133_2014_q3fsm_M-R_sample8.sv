module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // One-hot state encoding
    reg [1:0] state;
    localparam A = 2'b01;
    localparam B = 2'b10;

    // Phase counter (0-2)
    reg [1:0] phase;

    // W history shift register
    reg [2:0] w_history;

    // Next state logic
    wire next_state_A = reset ? 1'b1 : (state == A) ? ~s : 1'b0;
    wire next_state_B = reset ? 1'b0 : (state == A) ? s : 1'b1;

    // Next phase (increments mod 3)
    wire [1:0] next_phase = reset ? 2'd0 : (state == B) ? (phase + 1'b1) : 2'd0;

    // Next w history (shift in new w when in B state)
    wire [2:0] next_w_history = reset ? 3'b000 : (state == B) ? {w_history[1:0], w} : 3'b000;

    // Output logic - check when phase wraps and exactly 2 ones in history
    wire two_ones = (w_history[0] + w_history[1] + w_history[2]) == 2'd2;
    assign z = (state == B) && (phase == 2'd0) && two_ones;

    // Sequential updates
    always @(posedge clk) begin
        state <= {next_state_B, next_state_A};
        phase <= next_phase;
        w_history <= next_w_history;
    end

endmodule