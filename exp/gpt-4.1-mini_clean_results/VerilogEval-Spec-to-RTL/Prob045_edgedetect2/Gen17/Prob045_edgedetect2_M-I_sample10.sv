module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] edge_detect;
    wire edge_any;

    assign edge_detect = in ^ prev_in;   // combinational XOR to detect edges
    assign edge_any = |edge_detect;      // detect if any bit changed

    always @(posedge clk) begin
        prev_in <= in;                  // update previous input
        if (edge_any)
            anyedge <= edge_detect;     // only update anyedge if there is an edge
        else
            anyedge <= anyedge;         // hold previous value, avoid toggling
    end
endmodule