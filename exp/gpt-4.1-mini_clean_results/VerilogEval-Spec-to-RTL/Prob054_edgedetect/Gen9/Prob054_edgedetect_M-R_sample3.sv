module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detect;

    always @(posedge clk) begin
        // Detect edges based on previous input
        edge_detect <= (~prev_in) & in;
        prev_in <= in;
        // Register the detected edges with a cycle delay
        pedge <= edge_detect;
    end

endmodule