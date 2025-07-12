module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn)
        q <= 16'b0;
    else begin
        // Create mask: each byte is either all ones or zeros depending on byteena
        // byteena[1] controls bits [15:8], byteena[0] controls bits [7:0]
        wire [15:0] mask = { {8{byteena[1]}}, {8{byteena[0]}} };
        q <= (q & ~mask) | (d & mask);
    end
end

endmodule