module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg [63:0] complement_mask;  // Large enough for practical input lengths
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            complement_mask <= 64'b0;
        end
        else begin
            // Shift left and set LSB if we see a 1 and mask is still 0
            complement_mask <= {complement_mask[62:0], (x & ~|complement_mask)};
        end
    end

    assign z = x ^ complement_mask[0];

endmodule