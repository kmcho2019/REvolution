module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    wire next_state;

    assign next_state = (~a & b) ? 1'b1 :
                        (a & b)  ? 1'b0 :
                                   state;

    assign q = state & b;

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule