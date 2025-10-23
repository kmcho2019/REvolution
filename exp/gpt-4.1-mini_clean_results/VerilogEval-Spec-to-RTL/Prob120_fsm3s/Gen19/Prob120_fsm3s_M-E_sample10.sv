module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // Define states using localparams for clarity
    localparam A = 2'd0;
    localparam B = 2'd1;
    localparam C = 2'd2;
    localparam D = 2'd3;

    reg [1:0] state, next_state;

    // Synchronous process for state and output
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output: output depends only on current state after state update
            out <= (next_state == D) ? 1'b1 : 1'b0;
        end
    end

    // Combinational next state logic
    always @(*) begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

endmodule