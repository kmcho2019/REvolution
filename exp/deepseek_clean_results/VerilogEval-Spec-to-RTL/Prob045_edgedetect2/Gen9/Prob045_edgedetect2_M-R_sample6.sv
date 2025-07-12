module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;

    // Sequential part: Store previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational part: Edge detection
    assign anyedge = in ^ prev_in;

endmodule