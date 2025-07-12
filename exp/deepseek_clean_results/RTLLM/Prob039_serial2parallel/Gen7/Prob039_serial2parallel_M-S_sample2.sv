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
                // Shift in new bit and check if we've collected 8 bits
                dout_parallel <= {dout_parallel[6:0], din_serial};
                
                // MSB will be set after 8 shifts, indicating complete word
                if (dout_parallel[7]) begin
                    dout_valid <= 1'b1;
                end
            end
        end
    end

endmodule