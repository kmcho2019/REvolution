module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;

    // Store current input as previous input at each clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Output is high for bits where input changed from previous cycle (delayed edge detection)
    assign anyedge = in ^ prev_in;

endmodule