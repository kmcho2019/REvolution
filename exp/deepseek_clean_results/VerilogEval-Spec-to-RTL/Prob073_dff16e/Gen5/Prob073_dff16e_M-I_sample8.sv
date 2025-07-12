module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    wire [15:0] byte_enable_mask = {
        {8{byteena[1]}},  // Upper byte enable mask
        {8{byteena[0]}}   // Lower byte enable mask
    };

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            q <= (d & byte_enable_mask) | (q & ~byte_enable_mask);
        end
    end

endmodule