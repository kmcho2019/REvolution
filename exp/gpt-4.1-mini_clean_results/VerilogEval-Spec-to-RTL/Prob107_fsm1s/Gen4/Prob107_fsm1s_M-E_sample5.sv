module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;  // Output for B
        end else begin
            // Update state based on current state and input
            case(state)
                B: begin
                    if (in == 1'b0)
                        state <= A;
                    else
                        state <= B;
                end
                A: begin
                    if (in == 1'b0)
                        state <= B;
                    else
                        state <= A;
                end
                default: state <= B; // safe default
            endcase

            // Output depends only on state (Moore)
            out <= (state == B) ? 1'b1 : 1'b0;
        end
    end

endmodule