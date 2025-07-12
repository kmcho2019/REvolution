module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] previous_state;
reg [7:0] pedge_next;

// Initialize previous state to 0
initial begin
    previous_state = 8'b0;
end

// Detect rising edge
always @(posedge clk) begin
    pedge_next = 8'b0;
    for (int i = 0; i < 8; i++) begin
        if (~previous_state[i] && in[i]) begin
            pedge_next[i] = 1'b1;
        end
    end
    previous_state <= in;
    pedge <= pedge_next;
end

endmodule