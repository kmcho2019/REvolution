module TopModule (
    input clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detected;

    assign edge_detected = in ^ prev_in;

    always @(posedge clk) begin
        prev_in <= in;
        anyedge <= edge_detected;
    end

endmodule