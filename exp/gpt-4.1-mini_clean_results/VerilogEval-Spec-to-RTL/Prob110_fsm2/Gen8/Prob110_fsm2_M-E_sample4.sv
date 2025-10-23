module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    reg state;

    // Asynchronous reset with combined state and output update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // OFF state
        else begin
            case (state)
                1'b0: state <= j ? 1'b1 : 1'b0; // OFF: j=1 -> ON
                1'b1: state <= k ? 1'b0 : 1'b1; // ON: k=1 -> OFF
                default: state <= 1'b0;
            endcase
        end
    end

    // Moore output: output equals current state (OFF=0, ON=1)
    assign out = state;

endmodule