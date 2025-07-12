module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire clk_enable;
    wire gated_clk;

    // Clock gating control - enable only when input changes
    assign clk_enable = (in != prev_in);
    assign gated_clk = clk & clk_enable;

    always @(posedge gated_clk) begin
        // Edge detection using XOR - most efficient method
        anyedge <= in ^ prev_in;
        
        // Store current input for next cycle comparison
        prev_in <= in;
    end

    // Handle case when clock is gated (maintain previous output)
    always @(posedge clk) begin
        if (!clk_enable) begin
            anyedge <= anyedge;
        end
    end

endmodule