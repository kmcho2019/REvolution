module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding using parameters for clarity and tool compatibility
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Sequential logic: state and registered output update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1; // output for reset state B
        end else begin
            state <= next_state;
            // Moore output depends only on current state (before update)
            case(next_state)
                B: out <= 1'b1;
                A: out <= 1'b0;
                default: out <= 1'b1;
            endcase
        end
    end

endmodule