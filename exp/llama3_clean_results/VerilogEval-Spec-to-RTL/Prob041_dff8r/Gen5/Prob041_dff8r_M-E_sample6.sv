module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic [7:0] shift_register;

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 8'b0;
    end else begin
        shift_register <= {shift_register[6:0], d[0]};
    end
end

always_comb begin
    for (int i = 0; i < 8; i++) begin
        if (reset) begin
            q[i] = 1'b0;
        end else begin
            q[i] = shift_register[i];
        end
    end
end

endmodule