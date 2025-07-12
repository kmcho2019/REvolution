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

    // Phase counter (0-2) using modulo-3 arithmetic
    reg [1:0] phase;

    // 3-bit shift register for w history
    reg [2:0] w_history;

    // Combinational next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Combinational phase update (modulo 3)
    wire [1:0] next_phase = (state == B) ? ((phase == 2'd2) ? 2'd0 : phase + 1'b1) : 2'd0;

    // Combinational shift register update
    wire [2:0] next_w_history = (state == B) ? {w_history[1:0], w} : 3'b000;

    // Popcount calculation (combinational)
    wire [1:0] popcount = w_history[0] + w_history[1] + w_history[2];

    // Output logic
    assign z = (state == B) && (phase == 2'd0) && (popcount == 2'd2);

    // Single sequential always block
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase <= 2'd0;
            w_history <= 3'b000;
        end else begin
            state <= next_state;
            phase <= next_phase;
            w_history <= next_w_history;
        end
    end

endmodule