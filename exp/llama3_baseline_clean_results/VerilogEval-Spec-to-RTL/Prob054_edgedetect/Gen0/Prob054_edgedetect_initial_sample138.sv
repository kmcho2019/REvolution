module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store previous state of input vector
reg [7:0] pedge;   // Output register

always @(posedge clk) begin
    // Initialize the output to 0
    pedge <= 8'b0;

    // Compare current state with previous state to detect transitions
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 0 && in[i] == 1) begin
            // If transition is detected, set the corresponding output bit to 1
            pedge[i] <= 1;
        end
    end

    // Update the previous state register with the current state
    prev_in <= in;
end

endmodule