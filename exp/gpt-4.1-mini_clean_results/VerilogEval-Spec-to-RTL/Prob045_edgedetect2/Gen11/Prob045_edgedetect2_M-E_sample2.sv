module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detect;

    always @(posedge clk) begin
        // Detect edge between current input and previous input
        edge_detect <= in ^ prev_in;

        // Register previous input for next cycle
        prev_in <= in;

        // Output edge_detect delayed by one cycle to meet requirement
        anyedge <= edge_detect;
    end

endmodule