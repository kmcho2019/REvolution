module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    wire [15:0] byte_mask;
    wire [15:0] next_q;

    // Create a mask from byteena bits: replicate each bit to 8 bits
    assign byte_mask = { {8{byteena[1]}}, {8{byteena[0]}} };

    // Compute next q value by updating only enabled bytes, else keep old q
    assign next_q = (d & byte_mask) | (q & ~byte_mask);

    always @(posedge clk) begin
        if (!resetn)
            q <= 16'b0;
        else
            q <= next_q;
    end

endmodule