module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding
    localparam [1:0]
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3;

    reg [1:0] state, next_state;

    // Combinational next state logic using case statement
    always @(*) begin
        case(state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A;
        endcase
    end

    // Sequential logic: state and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state;
            // Output depends only on current state (Moore output)
            out <= (next_state == D) ? 1'b1 : 1'b0;
        end
    end

endmodule