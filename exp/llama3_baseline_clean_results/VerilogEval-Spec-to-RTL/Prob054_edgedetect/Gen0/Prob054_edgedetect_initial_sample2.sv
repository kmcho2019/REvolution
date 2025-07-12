module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_state;
reg [7:0] pedge;

always @ (posedge clk) begin
    pedge <= 8'b0; // Default output to 0
    for (int i = 0; i < 8; i++) begin
        if (in[i] && !prev_state[i]) begin
            pedge[i] <= 1'b1; // Set output to 1 if positive edge detected
        end
    end
    prev_state <= in; // Update previous state
end

endmodule