module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge,
    input enable  // Added enable signal for power optimization
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        if (enable) begin
            // Store previous input values only when enabled
            prev_in <= in;
            
            // Detect edges by XORing current and previous values
            anyedge <= in ^ prev_in;
        end
        else begin
            // When disabled, maintain previous state to prevent unnecessary toggling
            anyedge <= anyedge;
        end
    end

endmodule