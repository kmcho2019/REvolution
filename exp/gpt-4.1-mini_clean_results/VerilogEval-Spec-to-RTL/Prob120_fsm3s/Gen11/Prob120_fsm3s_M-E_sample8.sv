module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  out
);

    // State encoding
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;

    // Combinational next state logic using a case statement
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A;  // Default to state A on invalid state
        endcase
    end

    // Synchronous state and output registers with active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state;

            // Moore output: output depends only on the current state (next_state)
            out <= (next_state == D) ? 1'b1 : 1'b0;
        end
    end

endmodule