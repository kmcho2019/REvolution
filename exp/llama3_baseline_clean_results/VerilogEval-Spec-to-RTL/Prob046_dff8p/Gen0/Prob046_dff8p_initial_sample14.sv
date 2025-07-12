module DFF_SyncReset(
    input clk,
    input reset,
    input d,
    output reg q
);

// Synchronous reset on the negative edge of clk
always @(negedge clk) begin
    if(reset) begin
        // Reset value to 0x34 / 8 (since we're doing bit-by-bit, and 0x34 is for the whole 8 bits)
        // For individual bits, we need to check the bit position in the reset value
        q <= 1'b0; // This is a placeholder, actual implementation depends on the bit position
    end else begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Initialize reset value
reg [7:0] reset_value = 8'h34;

// Instantiate 8 D flip-flops with synchronous reset
genvar i;
generate
    for(i = 0; i < 8; i = i + 1) begin
        DFF_SyncReset dff_inst(
           .clk(clk),
           .reset(reset),
           .d(d[i]),
           .q(q[i])
        );
        
        // Override the reset value for each bit position
        // This is done within the TopModule because the reset value is known here
        // and it allows for easier modification if needed
        always @(negedge clk) begin
            if(reset) begin
                // Directly assign the correct reset bit
                q[i] <= reset_value[i];
            end
        end
    end
endgenerate

endmodule