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

    // Window tracking
    reg [1:0] cycle_count;  // Modulo-3 counter (0-2)
    reg [2:0] w_history;    // Shift register for w values

    // Continuous assignments for combinational logic
    wire next_state = reset ? A : (state == A ? (s ? B : A) : B);
    wire counter_wrap = (cycle_count == 2'd2);
    wire next_counter = reset ? 2'd0 : (state == B ? (counter_wrap ? 2'd0 : cycle_count + 1'b1) : 2'd0);
    wire [2:0] next_history = reset ? 3'b0 : (state == B ? {w_history[1:0], w} : 3'b0);

    // Output logic (combinational)
    wire [1:0] ones_count = w_history[0] + w_history[1] + w_history[2];
    assign z = (state == B) && counter_wrap && (ones_count == 2'd2);

    // Sequential logic (flip-flops)
    always @(posedge clk) begin
        state <= next_state;
        cycle_count <= next_counter;
        w_history <= next_history;
    end

endmodule