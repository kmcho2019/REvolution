module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(posedge ena or negedge ena) begin
    if (ena) begin
        q <= d;
    end else begin
        // No need for explicit assignment when ena is low; q retains its value.
    end
end

endmodule