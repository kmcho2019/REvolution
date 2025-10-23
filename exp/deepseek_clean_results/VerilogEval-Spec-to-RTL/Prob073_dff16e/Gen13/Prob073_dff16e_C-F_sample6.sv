module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // Create enable mask for each bit
    wire [15:0] enable_mask = {
        {8{byteena[1]}},  // Upper byte enable
        {8{byteena[0]}}   // Lower byte enable
    };

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Update only enabled bits
            q <= (d & enable_mask) | (q & ~enable_mask);
        end
    end

endmodule