module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] in_reg;
    wire input_changed = (in != in_reg);
    wire [7:0] edge_detect = in_reg ^ prev_in;

    always @(posedge clk) begin
        // First pipeline stage - register input
        in_reg <= in;
        
        // Second pipeline stage - edge detection
        if (input_changed) begin
            anyedge <= edge_detect;
            prev_in <= in_reg;
        end else begin
            anyedge <= 8'b0;
        end
    end

endmodule