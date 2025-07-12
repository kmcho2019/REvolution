module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= '0;
        end else begin
            q <= d;
        end
    end

endmodule