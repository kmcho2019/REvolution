module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg phase_toggle;  // Toggles every cycle in state B
    reg [2:0] w_history;

    // Output is high when:
    // 1. In state B
    // 2. At start of 3-cycle window (phase_toggle just toggled)
    // 3. Exactly two 1's in w_history
    assign z = (state == B) && (phase_toggle == 1'b0) && 
               ((w_history[0] + w_history[1] + w_history[2]) == 2'd2;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase_toggle <= 1'b0;
            w_history <= 3'b000;
        end else begin
            case (state)
                A: begin
                    state <= s ? B : A;
                    phase_toggle <= 1'b0;
                end
                B: begin
                    w_history <= {w_history[1:0], w};
                    phase_toggle <= ~phase_toggle;
                end
            endcase
        end
    end

endmodule