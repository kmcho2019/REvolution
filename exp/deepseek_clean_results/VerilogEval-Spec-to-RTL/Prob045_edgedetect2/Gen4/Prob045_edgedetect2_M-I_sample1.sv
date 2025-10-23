module TopModule (
    input clk,
    input enable,      // Added enable signal for power optimization
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detect;  // Pipeline register for timing improvement

    always @(posedge clk) begin
        if (enable) begin
            // Store previous input values
            prev_in <= in;
            
            // First pipeline stage: edge detection
            edge_detect <= in ^ prev_in;
            
            // Second pipeline stage: output register
            anyedge <= edge_detect;
        end else begin
            // When disabled, maintain previous values
            prev_in <= prev_in;
            edge_detect <= 8'b0;
            anyedge <= 8'b0;
        end
    end

endmodule