module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg ready;          // Flag indicating first byte is ready
reg [7:0] upper_byte;  // Storage for first byte

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ready <= 1'b0;
        upper_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default output
        
        if (valid_in) begin
            if (!ready) begin
                // First byte - store and set ready flag
                upper_byte <= data_in;
                ready <= 1'b1;
            end else begin
                // Second byte - combine and output
                data_out <= {upper_byte, data_in};
                valid_out <= 1'b1;
                ready <= 1'b0;
            end
        end
    end
end

endmodule