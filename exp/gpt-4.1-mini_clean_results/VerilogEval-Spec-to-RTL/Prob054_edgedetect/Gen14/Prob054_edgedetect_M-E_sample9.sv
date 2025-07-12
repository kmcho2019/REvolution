module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] in_d1, in_d2;
    wire [7:0] edge_detect;

    // Pipeline input through two registers
    always @(posedge clk) begin
        in_d1 <= in;
        in_d2 <= in_d1;
    end

    // Combinational edge detection comparing delayed inputs
    assign edge_detect = (~in_d2) & in_d1;

    // Register the detected edges, output delayed by one clock cycle
    always @(posedge clk) begin
        pedge <= edge_detect;
    end

endmodule