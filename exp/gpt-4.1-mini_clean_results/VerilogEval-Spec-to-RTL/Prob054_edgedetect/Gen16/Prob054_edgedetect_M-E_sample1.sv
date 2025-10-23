module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] pedge_next;

    always @(posedge clk) begin
        // Stage 1: update prev_in with current input
        prev_in <= in;
    end

    always @(posedge clk) begin
        // Stage 2: detect positive edges comparing prev_in with current input delayed by one cycle
        pedge <= (~prev_in) & in;
    end

endmodule