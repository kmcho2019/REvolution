module TopModule #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= '0;
    end else begin
        q <= d;
    end
end

endmodule