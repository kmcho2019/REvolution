module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;
reg [7:0] pedge;

always @(posedge clk) begin
    // Update previous state
    prev_in <= in;
    
    // Detect positive edge transitions
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 0 && in[i] == 1) begin
            pedge[i] <= 1'b1;
        end else begin
            pedge[i] <= 1'b0;
        end
    end
end

endmodule