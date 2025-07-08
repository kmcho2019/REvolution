module TopModule (
    input  wire        clk,
    input  wire [7:0]  in,
    output reg  [7:0]  pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        pedge <= (~prev_in) & in;  // Detect 0->1 transition on each bit
        prev_in <= in;             // Store current input for next comparison
    end

endmodule