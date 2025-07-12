module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end else begin
        q <= d;
    end
end

// Alternatively, a more concise version can be written as:
// always_ff @(posedge clk)
//     q <= reset ? 8'b0 : d;

endmodule