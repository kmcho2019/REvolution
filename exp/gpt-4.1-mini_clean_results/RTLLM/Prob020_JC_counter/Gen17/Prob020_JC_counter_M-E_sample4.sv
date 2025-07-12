module JC_counter (
    input  wire        clk,
    input  wire        rst_n,
    output reg [63:0]  Q
);

reg [31:0] Q_lo;
reg [31:0] Q_hi;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q_lo <= 32'b0;
        Q_hi <= 32'b0;
        Q    <= 64'b0;
    end else begin
        // Update low 32-bit Johnson counter
        Q_lo <= {~Q_lo[0], Q_lo[31:1]};
        
        // Update high 32-bit Johnson counter,
        // MSB driven by inversion of Q_lo LSB instead of Q_hi's own LSB
        Q_hi <= {~Q_lo[0], Q_hi[31:1]};
        
        // Concatenate to form the 64-bit output
        Q <= {Q_hi, Q_lo};
    end
end

endmodule