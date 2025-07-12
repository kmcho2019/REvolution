module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // register to store previous state
reg [7:0] pedge_reg; // register to store output

// Detect 0 to 1 transitions and store the result in pedge_reg
always @(*) begin
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 0 && in[i] == 1) begin
            pedge_reg[i] = 1;
        end else begin
            pedge_reg[i] = 0;
        end
    end
end

// Update previous state and output on every positive clock edge
always @(posedge clk) begin
    prev_in <= in;
    pedge <= pedge_reg;
end

endmodule