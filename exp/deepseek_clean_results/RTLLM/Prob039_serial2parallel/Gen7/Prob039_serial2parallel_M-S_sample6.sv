module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default to invalid
            
            if (din_valid) begin
                dout_parallel <= {dout_parallel[6:0], din_serial};
                
                // Check if we've just shifted in the 8th bit
                if (&dout_parallel[6:0]) begin  // All bits 1 means we've collected 7 previous bits
                    dout_valid <= 1'b1;
                end
            end
        end
    end

endmodule