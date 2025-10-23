module TopModule (
    input            clk,
    input      [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] pedge_next;

    always @(posedge clk) begin
        // Detect edges: previous=0 and current=1
        pedge_next <= (~prev_in) & in;
        // Output pedge delayed by one cycle
        pedge <= pedge_next;
        // Store current input for next comparison
        prev_in <= in;
    end

endmodule