module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of the input signal

always @(posedge clk) begin
    prev_in <= in; // Update the previous state at every positive clock edge
end

always @(*) begin
    pedge = 8'b0; // Initialize the output with all zeros
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 1'b0 && in[i] == 1'b1) begin
            pedge[i] = 1'b1; // Set the output bit if a positive edge transition is detected
        end
    end
end

endmodule