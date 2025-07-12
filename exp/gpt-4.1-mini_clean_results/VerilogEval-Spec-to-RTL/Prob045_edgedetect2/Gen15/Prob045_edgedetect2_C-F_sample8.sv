module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;

    wire input_changed = (in != in_dly);

    always @(posedge clk) begin
        if (input_changed) begin
            anyedge <= in ^ in_dly;  // Set anyedge bits where input changed
            in_dly <= in;            // Update delayed input only when input changes
        end else begin
            anyedge <= 8'b0;         // Clear anyedge when no change
            // in_dly remains same to avoid unnecessary toggling
        end
    end
endmodule