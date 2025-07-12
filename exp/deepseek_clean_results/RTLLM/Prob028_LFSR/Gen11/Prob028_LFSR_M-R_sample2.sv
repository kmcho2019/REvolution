module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;

// Combinational feedback logic
assign feedback = out[3] ^ out[2];

// Sequential state update
always @(posedge clk or posedge rst) begin
    if (rst)
        out <= 4'b0001;
    else
        out <= {out[2:0], feedback};
end

endmodule