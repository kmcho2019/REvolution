module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    anyedge = 8'b0; // Initialize anyedge to 0
    for (int i = 0; i < 8; i++) begin
        if (in[i]!= prev_in[i]) begin
            anyedge[i] = 1'b1; // Set the output bit to 1 if there is a transition
        end
    end
    prev_in = in; // Update the previous state
end

endmodule