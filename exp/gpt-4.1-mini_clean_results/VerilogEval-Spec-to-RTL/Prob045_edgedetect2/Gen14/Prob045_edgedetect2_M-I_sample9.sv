module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    assign edge_detect = in ^ prev_in;

    always @(posedge clk) begin
        prev_in <= in;
        if (|edge_detect)  // update anyedge only if any bit toggled
            anyedge <= edge_detect;
        else
            anyedge <= anyedge; // hold previous value to reduce toggling
    end
endmodule