module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        Q <= q_in;
    end else begin
        Q <= r_in; // This will be connected to a combinational logic in the full_module
    end
end

endmodule