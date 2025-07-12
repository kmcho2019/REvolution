module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first_byte;
reg [7:0] first_byte;

// State and data storage
always @(posedge clk) begin
    if (!rst_n) begin
        has_first_byte <= 1'b0;
        first_byte <= 8'b0;
    end else begin
        if (valid_in) begin
            if (!has_first_byte) begin
                first_byte <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                has_first_byte <= 1'b0;
            end
        end
    end
end

// Output generation
always @(posedge clk) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0; // Default
        
        if (valid_in && has_first_byte) begin
            data_out <= {first_byte, data_in};
            valid_out <= 1'b1;
        end
    end
end

endmodule