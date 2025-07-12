module TopModule (
    input clk,
    input in,
    output reg out
);

    // State definition
    reg state;

    always @(posedge clk) begin
        case(state)
            1'b0: state <= in ^ 1'b0;
            1'b1: state <= in ^ 1'b1;
        endcase
        out <= state;
    end

endmodule