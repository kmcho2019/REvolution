module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] anyedge;

always @(posedge clk) begin
    anyedge <= 8'd0; // Default anyedge to 0
    for (int i = 0; i < 8; i++) begin
        if (in[i] != prev_in[i]) begin
            anyedge[i] <= 1'b1; // Set anyedge to 1 if transition is detected
        end
    end
    prev_in <= in; // Update previous input value
end

endmodule