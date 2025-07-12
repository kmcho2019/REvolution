module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Phase counter (0-2) and w history
    reg [1:0] phase;
    reg [2:0] w_history;
    reg [1:0] popcount;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase <= 2'd0;
            w_history <= 3'b0;
            popcount <= 2'd0;
            z <= 1'b0;
        end else begin
            // State transition
            state <= (state == A) ? (s ? B : A) : B;

            // Phase and w_history update
            if (state == B) begin
                phase <= (phase == 2'd2) ? 2'd0 : phase + 1'b1;
                w_history <= {w_history[1:0], w};
                
                // Popcount calculation (sequential)
                if (phase == 2'd2) begin
                    popcount <= w_history[0] + w_history[1] + w;
                end
            end else begin
                phase <= 2'd0;
                w_history <= 3'b0;
            end

            // Output logic (registered)
            z <= (state == B) && (phase == 2'd0) && (popcount == 2'd2);
        end
    end

endmodule