module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    assign edge_detect = in ^ prev_in;  // combinational XOR for edge detection

    always @(posedge clk) begin
        prev_in  <= in;          // store current input for next cycle comparison
        anyedge  <= edge_detect; // register edge detection output
    end
endmodule