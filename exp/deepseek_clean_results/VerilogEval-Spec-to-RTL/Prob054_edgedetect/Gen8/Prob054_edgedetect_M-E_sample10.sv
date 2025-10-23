module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    // 2-stage shift register for each bit (stores current and previous state)
    reg [1:0] bit_history [7:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            bit_history[i] <= {bit_history[i][0], in[i]};
            
            // Detect positive edge (01 pattern)
            pedge[i] <= (bit_history[i] == 2'b01);
        end
    end

endmodule