module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'd0;
    end else begin
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        out <= {out[2:0], feedback};
    end
end

endmodule