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

    reg [1:0] phase;
    reg [2:0] w_history;

    // Popcount calculation
    wire [1:0] popcount = w_history[0] + w_history[1] + w_history[2];

    // Output when in state B, at phase 0, and exactly two 1's in w_history
    assign z = (state == B) && (phase == 2'd0) && (popcount == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase <= 2'd0;
        end else begin
            case (state)
                A: state <= s ? B : A;
                B: begin
                    w_history <= {w_history[1:0], w};
                    phase <= (phase == 2'd2) ? 2'd0 : phase + 1'b1;
                end
            endcase
        end
    end

endmodule