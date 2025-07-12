module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pipeline stage 1: Control signals
reg rotate_left, rotate_right;
always @(posedge clk) begin
    rotate_left <= (ena == 2'b10) & ~load;
    rotate_right <= (ena == 2'b01) & ~load;
end

// Pipeline stage 2: Bitwise rotation with clock gating
genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin: rotate_bits
        always @(posedge clk) begin
            if (load) begin
                q[i] <= data[i];
            end else if (rotate_left) begin
                q[i] <= (i == 99) ? q[0] : q[i+1];
            end else if (rotate_right) begin
                q[i] <= (i == 0) ? q[99] : q[i-1];
            end
        end
    end
endgenerate

endmodule