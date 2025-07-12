module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock  <= 8'b0;
        data_out   <= 16'b0;
        valid_out <= 1'b0;
    end
    else begin
        valid_out <= 1'b0;  // Default to invalid
        
        if (valid_in) begin
            if (data_lock == 8'b0) begin
                // Store first byte
                data_lock <= data_in;
            end
            else begin
                // Concatenate and output
                data_out  <= {data_lock, data_in};
                valid_out <= 1'b1;
                data_lock <= 8'b0;  // Ready for next pair
            end
        end
    end
end

endmodule