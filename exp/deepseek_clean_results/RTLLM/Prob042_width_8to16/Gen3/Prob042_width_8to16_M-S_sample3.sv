module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first;
reg [7:0] first_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default invalid
        
        if (valid_in) begin
            if (!has_first) begin
                first_byte <= data_in;
                has_first <= 1'b1;
            end else begin
                data_out <= {first_byte, data_in};
                valid_out <= 1'b1;
                has_first <= 1'b0;
            end
        end
    end
end

endmodule