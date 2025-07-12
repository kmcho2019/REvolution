module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;

    // Asynchronous reset and state machine
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            state <= 1;
        end else begin
            case (state)
                0: state <= in? 0 : 1;
                1: state <= in? 1 : 0;
                default: state <= 1;
            endcase
        end
    end

    // Output logic
    assign out = state;

endmodule