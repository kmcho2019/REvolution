module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding
    localparam [1:0]
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3;

    reg [1:0] current_state, next_state;

    // Sequential logic: state register with async reset, and Moore output update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
            out <= 1'b0;
        end else begin
            current_state <= next_state;
            // Moore output depends only on current_state (after update)
            out <= (next_state == D);
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A;
        endcase
    end

endmodule