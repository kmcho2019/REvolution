module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_register;

always @(posedge clk) begin
    if (!resetn) begin
        shift_register <= 4'd0;
    end else begin
        for (int i = 3; i > 0; i--) begin
            shift_register[i] <= shift_register[i-1];
        end
        shift_register[0] <= in;
    end
end

assign out = shift_register[3];

endmodule