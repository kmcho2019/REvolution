module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Edge detection (combinational XOR of current input and previous input)
    assign edge_detect = in ^ prev_in;

    // Sequential logic: update prev_in and register edge_detect into anyedge
    always @(posedge clk) begin
        prev_in <= in;
        anyedge <= edge_detect;
    end
endmodule