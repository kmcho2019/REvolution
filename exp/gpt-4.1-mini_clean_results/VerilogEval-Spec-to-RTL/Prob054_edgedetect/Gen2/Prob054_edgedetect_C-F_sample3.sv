module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        pedge   <= (~prev_in) & in; // register detected 0->1 transitions
        prev_in <= in;              // store current input for next cycle comparison
    end

endmodule