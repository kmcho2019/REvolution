module TopModule (
    input clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    // Register the previous input at every clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Compute edge detection one cycle after input changes
    always @(posedge clk) begin
        anyedge <= in ^ prev_in;
    end

endmodule