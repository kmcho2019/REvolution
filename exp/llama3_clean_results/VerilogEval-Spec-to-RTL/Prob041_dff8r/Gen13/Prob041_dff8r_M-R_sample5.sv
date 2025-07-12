module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

always_ff @(posedge clk) begin
    if (reset) begin
        for (int i = 0; i < 8; i++) begin
            q[i] <= 1'b0;
        end
    end else begin
        q <= d;
    end
end

endmodule