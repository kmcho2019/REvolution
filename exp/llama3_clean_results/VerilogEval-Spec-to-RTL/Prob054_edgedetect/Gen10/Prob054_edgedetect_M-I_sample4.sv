module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

// Internal signals for sequential logic
reg [7:0] prev_in;
reg [7:0] pedge_reg;

// Combinational logic for edge detection
wire [7:0] edge_detect;

// Assign edge detection using bitwise AND and NOT operations
assign edge_detect = in & (~prev_in);

// Clock gating to reduce dynamic power consumption
reg clk_gated;
assign clk_gated = (in != prev_in); // Enable clock only when input changes

// Sequential logic with clock gating
always @(posedge clk) begin
    if (clk_gated) begin // Update only when input changes
        prev_in <= in;
        pedge_reg <= edge_detect;
    end
end

// Output assignment
assign pedge = pedge_reg;

endmodule