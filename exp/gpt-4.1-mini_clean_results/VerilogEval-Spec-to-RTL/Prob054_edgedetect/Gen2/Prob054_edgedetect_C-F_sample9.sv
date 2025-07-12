module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        pedge <= (~prev_in) & in; // Detect 0-to-1 transitions between prev_in and in
        prev_in <= in;             // Update prev_in with current input
    end

endmodule