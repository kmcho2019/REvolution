module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

reg reset_out;
reg data_out;

always @(posedge clk) begin
    // Reset latch
    if (r) begin
        reset_out <= 1'b0;
    end else begin
        reset_out <= 1'bx;
    end

    // Data latch
    if (!r) begin
        data_out <= d;
    end else begin
        data_out <= 1'bx;
    end

    // Output assignment
    if (r) begin
        q <= reset_out;
    end else begin
        q <= data_out;
    end
end

endmodule