module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Circular shift register for enable signals
reg [7:0] enable_shift = 8'b00000001;

always @(posedge clk) begin
    if (reset) begin
        enable_shift <= 8'b00000001;
    end else begin
        enable_shift <= {enable_shift[6:0], enable_shift[7]};
    end
end

// Array of 8 D flip-flops with individual enables
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_array
        reg q_bit;
        
        always @(posedge clk) begin
            if (reset) begin
                q_bit <= 1'b0;
            end else if (enable_shift[i]) begin
                q_bit <= d[i];
            end
        end
        
        assign q[i] = q_bit;
    end
endgenerate

endmodule