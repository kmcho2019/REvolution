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

    // Phase counter (0-2) and w history
    reg [1:0] phase;
    reg [2:0] w_history;

    // Continuous assignments for next values
    wire next_state = reset ? A : (state == A ? (s ? B : A) : B);
    wire [1:0] next_phase = reset ? 2'd0 : (state == B ? (phase == 2'd2 ? 2'd0 : phase + 1'b1) : 2'd0);
    wire [2:0] next_w_history = reset ? 3'b0 : (state == B ? {w_history[1:0], w} : 3'b0);

    // Popcount and output logic
    wire [1:0] popcount = w_history[0] + w_history[1] + w_history[2];
    assign z = (state == B) && (phase == 2'd0) && (popcount == 2'd2);

    // Single always block for sequential elements
    always @(posedge clk) begin
        state <= next_state;
        phase <= next_phase;
        w_history <= next_w_history;
    end

endmodule