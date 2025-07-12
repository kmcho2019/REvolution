module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding: A=0, B=1 (output = state)
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // Reset to state B
        else begin
            case (state)
                1'b1: state <= (in == 1'b0) ? 1'b0 : 1'b1; // B: 0->A,1->B
                1'b0: state <= (in == 1'b0) ? 1'b1 : 1'b0; // A: 0->B,1->A
                default: state <= 1'b1;
            endcase
        end
    end

    // Output is the state (Moore machine output)
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1;
        else
            out <= state;
    end

endmodule