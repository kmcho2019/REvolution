module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output wire valid_out,
    output reg [15:0] data_out
);

// Internal registers
reg has_first_byte;
reg [7:0] first_byte_reg;

// State tracking
wire ready_for_output = has_first_byte & valid_in;

// Output assignment
assign valid_out = ready_for_output;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_byte <= 1'b0;
        first_byte_reg <= 8'b0;
        data_out <= 16'b0;
    end else begin
        if (valid_in) begin
            if (has_first_byte) begin
                // Combine bytes and output
                data_out <= {first_byte_reg, data_in};
                has_first_byte <= 1'b0;  // Ready for new pair
            end else begin
                // Store first byte
                first_byte_reg <= data_in;
                has_first_byte <= 1'b1;
            end
        end
    end
end

endmodule