module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 8'b0;
    end else begin
        q <= d;
    end
end

endmodule