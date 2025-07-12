module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_shift_reg;
reg has_first_byte;

// Data capture logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_shift_reg <= 8'b0;
        has_first_byte <= 1'b0;
    end else if (valid_in) begin
        if (!has_first_byte) begin
            data_shift_reg <= data_in;
            has_first_byte <= 1'b1;
        end else begin
            has_first_byte <= 1'b0;
        end
    end
end

// Output generation logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        valid_out <= 1'b0;
        if (valid_in && has_first_byte) begin
            data_out <= {data_shift_reg, data_in};
            valid_out <= 1'b1;
        end
    end
end

endmodule