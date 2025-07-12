module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // Register to store the previous state of 'in'

always @(posedge clk) begin
    // Store the current state of 'in' in 'prev_in' for the next clock cycle
    prev_in <= in;
    
    // Detect 0 to 1 transitions and update 'pedge' accordingly
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 0 && in[i] == 1) begin
            pedge[i] <= 1'b1;  // Set output bit to 1 if transition is detected
        end else begin
            pedge[i] <= 1'b0;  // Otherwise, set output bit to 0
        end
    end
end

endmodule