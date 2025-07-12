module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] posedge_comb;

    // Stage 1: store prev_in and compute posedge_comb (0->1 transition)
    always @(posedge clk) begin
        prev_in <= in;
    end

    assign posedge_comb = (~prev_in) & in;

    // Stage 2: register pedge output to reduce glitches and improve timing
    always @(posedge clk) begin
        pedge <= posedge_comb;
    end

endmodule