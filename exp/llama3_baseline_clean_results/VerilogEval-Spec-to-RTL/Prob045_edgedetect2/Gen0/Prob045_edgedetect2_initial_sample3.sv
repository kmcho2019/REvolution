module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;  // Register to store the previous input
reg [7:0] anyedge;  // Output register to store the edge detection result

always @ (posedge clk) begin
    prev_in <= in;  // Store the current input in the previous input register
    for (int i = 0; i < 8; i++) begin
        if (in[i]!= prev_in[i]) begin
            anyedge[i] <= 1'b1;  // Set the output bit to 1 if an edge is detected
        end else begin
            anyedge[i] <= 1'b0;  // Reset the output bit to 0 if no edge is detected
        end
    end
end

endmodule