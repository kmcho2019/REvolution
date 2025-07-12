module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of 'in'

always @ (posedge clk) begin
    // Update the previous state of 'in'
    prev_in <= in;
    
    // Initialize pedge to 0
    pedge <= 8'b0;
    
    // Detect positive edge transition and set the corresponding bit in 'pedge' to 1
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 1'b0 && in[i] == 1'b1) begin
            pedge[i] <= 1'b1;
        end
    end
end

endmodule