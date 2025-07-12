module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic slowena,
    output logic [3:0] q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 4'b0;
    end else if (slowena) begin
        if (q == 4'd9) begin
            q <= 4'b0;
        end else begin
            q <= q + 1;
        end
    end
end

endmodule