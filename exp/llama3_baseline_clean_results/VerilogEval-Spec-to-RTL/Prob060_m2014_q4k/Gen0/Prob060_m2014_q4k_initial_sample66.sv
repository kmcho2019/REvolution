module TopModule (
    input clk,
    input resetn,
    input in,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (!resetn) begin
        out <= 4'b0000; // reset the register to zero when resetn is low
    end else begin
        out <= {out[2:0], in}; // shift the input bit one position to the right
    end
end

endmodule