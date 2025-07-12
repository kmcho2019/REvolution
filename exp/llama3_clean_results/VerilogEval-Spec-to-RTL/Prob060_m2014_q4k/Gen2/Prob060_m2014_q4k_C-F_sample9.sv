module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_register;

always @(posedge clk) begin
    if (!resetn) begin
        shift_register[0] <= 1'b0;
        shift_register[1] <= 1'b0;
        shift_register[2] <= 1'b0;
        shift_register[3] <= 1'b0;
    end else begin
        shift_register[0] <= in;
        shift_register[1] <= shift_register[0];
        shift_register[2] <= shift_register[1];
        shift_register[3] <= shift_register[2];
    end
end

assign out = shift_register[3];

endmodule