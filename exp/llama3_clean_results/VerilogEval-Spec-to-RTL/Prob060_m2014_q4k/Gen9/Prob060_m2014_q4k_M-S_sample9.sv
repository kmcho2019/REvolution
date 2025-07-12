module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_register = 4'b0000;

always @(posedge clk) begin
    if (!resetn) shift_register <= 4'b0000;
    else shift_register <= {in, shift_register[3:1]};
end

assign out = shift_register[0];

endmodule