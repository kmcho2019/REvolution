module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    wire [15:0] byteena_mask;
    wire [15:0] next_q;

    // Expand each byte enable bit to cover its 8 bits
    assign byteena_mask = { {8{byteena[1]}}, {8{byteena[0]}} };

    // Compute next state: selectively update bytes enabled, keep others unchanged
    assign next_q = (q & ~byteena_mask) | (d & byteena_mask);

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            q <= next_q;
        end
    end

endmodule