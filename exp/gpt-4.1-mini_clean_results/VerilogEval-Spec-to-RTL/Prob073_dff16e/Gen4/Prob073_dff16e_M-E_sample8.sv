module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    wire [15:0] write_mask = { {8{byteena[1]}}, {8{byteena[0]}} };
    wire [15:0] next_q = (q & ~write_mask) | (d & write_mask);

    always @(posedge clk) begin
        if (!resetn)
            q <= 16'b0;
        else
            q <= next_q;
    end

endmodule