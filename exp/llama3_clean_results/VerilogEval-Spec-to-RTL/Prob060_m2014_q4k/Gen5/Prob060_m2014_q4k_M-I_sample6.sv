module TopModule #(
    parameter SHIFT_REGISTER_SIZE = 4
)(
    input clk,
    input resetn,
    input in,
    output out
);

reg [SHIFT_REGISTER_SIZE-1:0] shift_register;

always @(posedge clk) begin
    if (!resetn) begin
        shift_register <= {SHIFT_REGISTER_SIZE{1'b0}};
    end else begin
        shift_register <= {in, shift_register[SHIFT_REGISTER_SIZE-1:1]};
    end
end

assign out = shift_register[0];

endmodule