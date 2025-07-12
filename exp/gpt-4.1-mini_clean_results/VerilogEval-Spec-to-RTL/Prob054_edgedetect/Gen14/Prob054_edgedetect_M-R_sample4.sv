module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;
        // Detect 0->1 transition on previous input vs current input and output pedge one cycle delayed
        pedge <= (~prev_in) & in;
    end

endmodule