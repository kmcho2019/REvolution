module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;

    // Sequential logic: state update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            case(state)
                B: state <= (in) ? B : A;
                A: state <= (in) ? A : B;
                default: state <= B;
            endcase
        end
    end

    // Moore output depends only on state
    assign out = (state == B);

endmodule