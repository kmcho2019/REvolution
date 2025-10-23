module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // Enumerated states for clarity
    localparam B = 1'b0, A = 1'b1;

    reg state, next_state;

    // Sequential logic: state update and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1; // output corresponding to reset state B
        end else begin
            state <= next_state;
            // Output is Moore: depends only on current state
            case (next_state)
                B: out <= 1'b1;
                A: out <= 1'b0;
                default: out <= 1'b1;
            endcase
        end
    end

    // Combinational logic for next state and output (Moore output registered)
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

endmodule