module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'd0; // reset all bits
    end else begin
        case (byteena)
            2'b00: ; // do nothing
            2'b01: q[7:0] <= d[7:0]; // update lower byte
            2'b10: q[15:8] <= d[15:8]; // update upper byte
            2'b11: q <= d; // update both bytes
        endcase
    end
end

endmodule