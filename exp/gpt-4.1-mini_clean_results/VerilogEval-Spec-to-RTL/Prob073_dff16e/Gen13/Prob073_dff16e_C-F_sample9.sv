module TopModule (
    input          clk,
    input          resetn,
    input  [1:0]   byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

    // Create a 16-bit write enable mask based on byteena
    wire [15:0] wen_mask = { {8{byteena[1]}}, {8{byteena[0]}} };

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Update only bytes enabled by wen_mask; retain others
            q <= (q & ~wen_mask) | (d & wen_mask);
        end
    end

endmodule