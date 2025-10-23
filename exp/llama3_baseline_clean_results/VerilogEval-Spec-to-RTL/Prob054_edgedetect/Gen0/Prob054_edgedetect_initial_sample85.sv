module TopModule (
    input         clk,
    input  [7:0]  in,
    output [7:0] pedge
);

reg [7:0] prev_state;

always @(posedge clk) begin
    pedge <= 8'b0; // Initialize output to 0
    for (int i = 0; i < 8; i++) begin
        if (prev_state[i] == 1'b0 && in[i] == 1'b1) begin
            pedge[i] <= 1'b1; // Set output bit to 1 if transition is detected
        end
    end
    prev_state <= in; // Update previous state
end

initial begin
    prev_state = 8'b0; // Initialize previous state to 0
end

endmodule