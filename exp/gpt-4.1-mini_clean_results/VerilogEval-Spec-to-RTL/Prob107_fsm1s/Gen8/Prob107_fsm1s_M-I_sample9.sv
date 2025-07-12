module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // Sequential logic: state update and next state calculation combined
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1; // output for state B
        end else begin
            // Next state logic
            case (state)
                B: if (in == 1'b0)
                       state <= A;
                   else
                       state <= B;
                A: if (in == 1'b0)
                       state <= B;
                   else
                       state <= A;
                default: state <= B; // safety default
            endcase
            // Output depends on new state (Moore)
            out <= (state == B) ? 1'b1 : 1'b0;
        end
    end

endmodule