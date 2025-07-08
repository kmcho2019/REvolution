module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

    // Combinational logic for q based on current state and inputs
    assign q = (b & ~state) | (a & state);

    // Sequential logic: flip-flop storing q on posedge clk
    always @(posedge clk) begin
        state <= q;
    end

endmodule