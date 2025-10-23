module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

// Next state calculation using direct bit operations
wire next_Q = (Q ^ (j & k)) | (j & ~k);

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule