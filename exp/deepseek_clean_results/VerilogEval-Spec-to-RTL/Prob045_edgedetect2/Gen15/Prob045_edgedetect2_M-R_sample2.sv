module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;       // Sequential storage for previous input
    wire [7:0] edge_detect;  // Combinational edge detection

    // Combinational logic: detect edges using XOR
    assign edge_detect = in ^ prev_in;

    // Sequential logic: store previous input and register output
    always @(posedge clk) begin
        prev_in <= in;
        anyedge <= edge_detect;
    end

endmodule