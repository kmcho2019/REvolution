module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    localparam B = 2'b00;
    localparam A = 2'b01;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // State and output registers (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;
        end else begin
            state <= next_state;
            // Moore output depends only on current state
            case (next_state)
                B: out <= 1'b1;
                A: out <= 1'b0;
                default: out <= 1'b1;
            endcase
        end
    end

endmodule