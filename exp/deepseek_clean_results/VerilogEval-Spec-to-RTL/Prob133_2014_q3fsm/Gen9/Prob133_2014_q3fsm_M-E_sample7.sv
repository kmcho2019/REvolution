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

    // Sliding window registers
    reg [2:0] window;

    // Next state logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            window <= 3'b0;
            z <= 1'b0;
        end else begin
            // State transition
            case (state)
                A: state <= s ? B : A;
                B: state <= B;
            endcase

            // Update sliding window in state B
            if (state == B) begin
                window <= {window[1:0], w};
                
                // Continuous evaluation of window condition
                case (window)
                    3'b011, 3'b101, 3'b110: z <= 1'b1;
                    default: z <= 1'b0;
                endcase
            end else begin
                // Reset window and output in state A
                window <= 3'b0;
                z <= 1'b0;
            end
        end
    end

endmodule