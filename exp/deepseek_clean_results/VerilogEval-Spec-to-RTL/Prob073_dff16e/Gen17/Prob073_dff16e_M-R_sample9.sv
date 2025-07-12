module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);
    reg [15:0] q_reg;
    
    // Generate byte enable signals for each bit
    wire [15:0] bit_enable;
    assign bit_enable[15:8] = {8{byteena[1]}};  // Upper byte enable
    assign bit_enable[7:0]  = {8{byteena[0]}};   // Lower byte enable
    
    // Implement 16 DFFs with byte-level enables
    always @(posedge clk) begin
        if (!resetn) begin
            q_reg <= 16'b0;
        end else begin
            for (integer i = 0; i < 16; i = i + 1) begin
                if (bit_enable[i]) begin
                    q_reg[i] <= d[i];
                end
            end
        end
    end
    
    assign q = q_reg;
endmodule