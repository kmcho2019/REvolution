module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;
    wire clk_enable;

    // Combinational logic for edge detection
    assign edge_detect = in ^ prev_in;
    
    // Clock gating control - enable only when input changes
    assign clk_enable = (in != prev_in);

    // Sequential logic with clock gating
    always @(posedge clk) begin
        if (clk_enable) begin
            prev_in <= in;          // Store current input
            anyedge <= edge_detect; // Register the edge detection result
        end
    end

endmodule