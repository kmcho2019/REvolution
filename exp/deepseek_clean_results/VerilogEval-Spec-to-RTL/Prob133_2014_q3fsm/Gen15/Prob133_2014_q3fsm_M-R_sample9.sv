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

    // Next state logic (continuous assignment)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Phase counter update (continuous assignment)
    wire [1:0] next_phase = (state == B) ? ((phase == 2'd2) ? 2'd0 : phase + 1'b1) : 2'd0;

    // Shift register update (continuous assignment)
    wire [2:0] next_w_history = (state == B) ? {w_history[1:0], w} : 3'b000;

    // Popcount using explicit bit counting
    wire popcount_is_2 = (w_history[0] ^ w_history[1] ^ w_history[2]) & 
                        (w_history[0] | w_history[1] | w_history[2]);

    // Mealy output - depends on current state and history
    assign z = (state == B) && (phase == 2'd0) && popcount_is_2;

    // Single always block for sequential elements
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