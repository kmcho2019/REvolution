module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detected;

    // Combinational positive edge detection: detect bits that transitioned 0 -> 1
    assign edge_detected = (~prev_in) & in;

    always @(posedge clk) begin
        pedge <= edge_detected;  // Register the detected edges for output the next cycle
        prev_in <= in;
    end

endmodule