module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire input_changed = (in != prev_in);  // Only update when inputs change

    always @(posedge clk) begin
        // Edge detection using XOR
        anyedge <= in ^ prev_in;
        
        // Store current input only when it changes
        if (input_changed) begin
            prev_in <= in;
        end
    end

endmodule