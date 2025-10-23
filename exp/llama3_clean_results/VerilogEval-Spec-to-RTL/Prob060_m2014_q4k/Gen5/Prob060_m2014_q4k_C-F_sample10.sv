module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_register;

always_ff @(posedge clk) begin
    if (!resetn) begin
        for (int i = 0; i < 4; i++) begin
            shift_register[i] <= 1'b0;
        end
    end else begin
        shift_register <= {shift_register[2:0], in};
    end
end

assign out = shift_register[3];

endmodule