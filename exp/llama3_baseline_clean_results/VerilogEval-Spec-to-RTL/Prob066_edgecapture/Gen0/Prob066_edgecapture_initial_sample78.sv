module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] captured; // register to store captured bits
reg [31:0] prev_in; // register to store previous input

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        captured <= 32'd0;
    end else begin
        captured <= captured | (~in & prev_in); // capture bits that change from 1 to 0
    end
    prev_in <= in; // store current input for next clock cycle
end

assign out = captured;

endmodule