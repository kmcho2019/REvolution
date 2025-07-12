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

// Combinational logic for valid_out (registered in sequential block)
wire next_valid_out = has_first_byte & valid_in;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_byte <= 1'b0;
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= next_valid_out;
        
        if (valid_in) begin
            if (has_first_byte) begin
                // We have both bytes - output and clear
                data_out <= {first_byte, data_in};
                has_first_byte <= 1'b0;
            end else begin
                // Store first byte
                first_byte <= data_in;
                has_first_byte <= 1'b1;
            end
        end
    end
end

endmodule