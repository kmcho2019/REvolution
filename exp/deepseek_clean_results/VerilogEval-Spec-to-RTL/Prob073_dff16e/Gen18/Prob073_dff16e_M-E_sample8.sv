module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // Generate individual bit enable signals
    wire [15:0] bit_enable;
    assign bit_enable[15:8] = {8{byteena[1]}};
    assign bit_enable[7:0]  = {8{byteena[0]}};

    always @(posedge clk) begin
        // Update each bit conditionally
        for (integer i = 0; i < 16; i = i + 1) begin
            q[i] <= !resetn ? 1'b0 : 
                   bit_enable[i] ? d[i] : q[i];
        end
    end

endmodule