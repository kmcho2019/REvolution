module TopModule(
    input clk,
    input rst_n,  // Active low reset
    input [7:0] d,
    output logic [7:0] q
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= '0;  // Initialize q to 0 on reset
    end else begin
        q <= d;
    end
end

endmodule