module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // Create bit-level enable mask from byteena
    wire [15:0] enable_mask = {
        {8{byteena[1]}},  // Upper byte enable
        {8{byteena[0]}}   // Lower byte enable
    };

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'h0000;  // Synchronous reset
        end else begin
            // Update only enabled bits
            for (integer i = 0; i < 16; i = i + 1) begin
                if (enable_mask[i]) begin
                    q[i] <= d[i];
                end
            end
        end
    end

endmodule