// Novel TopModule implementation
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Use a reset signal to initialize outputs
reg reset;
initial begin
    reset = 1'b1;
    #10;
    reset = 1'b0;
end

// DFF array with shift register-like behavior
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        always @(posedge clk or posedge reset) begin
            if (reset) begin
                q[i] <= 1'b0;
            end else begin
                q[i] <= d[i];
            end
        end
    end
endgenerate

endmodule