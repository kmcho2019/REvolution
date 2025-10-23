module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= {8{1'b0}};
    end else begin
        q <= {d[7:0]};
    end
end

endmodule