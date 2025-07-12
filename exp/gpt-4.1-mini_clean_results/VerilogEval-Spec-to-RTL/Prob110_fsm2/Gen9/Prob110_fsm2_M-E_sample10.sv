module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    reg state;

    // Next state and state register with synchronous reset
    always @(posedge clk) begin
        if (areset)
            state <= 1'b0;  // OFF state
        else begin
            case (state)
                1'b0: state <= j ? 1'b1 : 1'b0; // OFF -> ON if j=1 else stay OFF
                1'b1: state <= k ? 1'b0 : 1'b1; // ON -> OFF if k=1 else stay ON
                default: state <= 1'b0;
            endcase
        end
    end

    // Output directly assigned from state (Moore output)
    assign out = state;

endmodule