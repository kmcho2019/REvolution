module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;
reg [7:0] pedge_reg;

wire [7:0] edge_detect; // New signal for combinational logic

// Combinational logic for edge detection
assign edge_detect = in & (~prev_in);

always @(posedge clk) begin
    prev_in <= in;
    pedge_reg <= edge_detect;
end

// Output assignment
assign pedge = pedge_reg;

endmodule