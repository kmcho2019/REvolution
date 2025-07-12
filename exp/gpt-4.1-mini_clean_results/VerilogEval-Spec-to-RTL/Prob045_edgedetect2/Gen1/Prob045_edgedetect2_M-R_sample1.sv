module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] edge;       // combinational edge detection
    reg [7:0] edge_reg;    // registered edge to delay output by one cycle

    assign edge = in ^ prev_in;   // detect edges combinationally

    always @(posedge clk) begin
        prev_in <= in;            // store current input for next cycle comparison
        edge_reg <= edge;         // register detected edge for output delay
        anyedge <= edge_reg;      // output is edge detected in previous cycle
    end
endmodule