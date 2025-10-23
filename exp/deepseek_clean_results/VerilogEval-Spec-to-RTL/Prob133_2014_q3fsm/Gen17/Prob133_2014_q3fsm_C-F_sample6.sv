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

    // Phase counter (0-2) for window tracking
    reg [1:0] phase;

    // 3-bit shift register for w history
    reg [2:0] w_history;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase <= 2'd0;
            w_history <= 3'b0;
        end else begin
            case (state)
                A: begin
                    if (s) state <= B;
                    phase <= 2'd0;
                    w_history <= 3'b0;
                end
                B: begin
                    w_history <= {w_history[1:0], w};
                    phase <= (phase == 2'd2) ? 2'd0 : phase + 1'b1;
                end
            endcase
        end
    end

    // Combinational outputs
    wire eval_now = (state == B) && (phase == 2'd2);
    wire [1:0] ones_count = w_history[0] + w_history[1] + w_history[2];
    assign z = eval_now ? (ones_count == 2'd2) : 1'b0;

endmodule