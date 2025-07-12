module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;
wire [3:0] next_out;

// Combinational feedback logic
assign feedback = out[3] ^ out[2];
assign next_out = {out[2:0], feedback};

// Sequential register update
always @(posedge clk) begin
    if (rst)
        out <= 4'b0001;
    else
        out <= next_out;
end

endmodule