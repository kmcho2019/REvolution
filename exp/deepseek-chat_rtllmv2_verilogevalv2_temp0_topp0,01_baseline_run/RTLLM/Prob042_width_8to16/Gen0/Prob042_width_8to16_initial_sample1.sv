module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg flag;               // Flag to indicate we have first byte stored
reg [7:0] data_lock;    // Register to store first byte

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        flag <= 1'b0;
        data_lock <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (!flag) begin
                // First byte: store it and set flag
                data_lock <= data_in;
                flag <= 1'b1;
            end
            else begin
                // Second byte: concatenate and output
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                flag <= 1'b0;
            end
        end
    end
end

endmodule