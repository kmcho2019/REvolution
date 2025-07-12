module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in, prev_prev_in;

    always @(posedge clk) begin
        prev_prev_in <= prev_in;    // oldest input sample
        prev_in <= in;              // newest input sample
        // pedge is 0->1 transition from prev_prev_in to prev_in, output registered
        pedge <= (~prev_prev_in) & prev_in;
    end

endmodule