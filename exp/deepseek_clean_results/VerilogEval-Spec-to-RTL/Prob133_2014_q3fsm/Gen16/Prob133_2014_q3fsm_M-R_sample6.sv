module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State definitions
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Phase counter (0-2)
    reg [1:0] phase;

    // Shift register for w values
    reg [2:0] w_history;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase <= 2'd0;
        end else begin
            case (state)
                A: state <= s ? B : A;
                B: phase <= (phase == 2'd2) ? 2'd0 : phase + 1'b1;
            endcase
        end
    end

    // Shift register logic
    always @(posedge clk) begin
        if (reset) begin
            w_history <= 3'b000;
        end else if (state == B) begin
            w_history <= {w_history[1:0], w};
        end else begin
            w_history <= 3'b000;
        end
    end

    // Popcount calculation
    wire [1:0] popcount = w_history[0] + w_history[1] + w_history[2];

    // Output generation
    assign z = (state == B) && (phase == 2'd0) && (popcount == 2'd2);

endmodule