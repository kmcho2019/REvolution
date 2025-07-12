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

    // Phase counter (0-2)
    reg [1:0] phase;

    // 3-bit shift register for w history
    reg [2:0] w_history;

    // Output logic: check for exactly two 1's in w_history
    wire exactly_two_ones = (w_history == 3'b011) || 
                          (w_history == 3'b101) || 
                          (w_history == 3'b110);

    assign z = (state == B) && (phase == 2'd0) && exactly_two_ones;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase <= 2'd0;
            w_history <= 3'b000;
        end else begin
            // State transition
            if (state == A)
                state <= s ? B : A;
            else
                state <= B;

            // Phase and history update
            if (state == B) begin
                w_history <= {w_history[1:0], w};
                phase <= (phase == 2'd2) ? 2'd0 : phase + 1'b1;
            end else begin
                phase <= 2'd0;
                w_history <= 3'b000;
            end
        end
    end

endmodule