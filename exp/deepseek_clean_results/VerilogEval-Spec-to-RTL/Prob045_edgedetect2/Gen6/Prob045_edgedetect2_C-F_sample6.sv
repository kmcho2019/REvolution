module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge,
    input enable  // Added for power optimization
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Combinational logic for edge detection
    assign edge_detect = in ^ prev_in;

    // Sequential logic with enable for power optimization
    always @(posedge clk) begin
        if (enable) begin
            prev_in <= in;          // Store current input only when enabled
            anyedge <= edge_detect; // Register the edge detection result
        end else begin
            anyedge <= 8'b0;       // Clear output when disabled
        end
    end

endmodule