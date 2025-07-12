module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // OFF state
        end else begin
            case(state)
                1'b0: state <= j ? 1'b1 : 1'b0;
                1'b1: state <= k ? 1'b0 : 1'b1;
                default: state <= 1'b0;
            endcase
        end
    end

    // Output follows state (Moore machine)
    always @(*) begin
        out = state;
    end

endmodule