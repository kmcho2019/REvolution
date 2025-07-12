module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first_byte;
reg [7:0] first_byte_reg;
reg next_valid_out;
reg [15:0] next_data_out;

// Synchronous reset handling
reg rst_n_sync;
always @(posedge clk) begin
    rst_n_sync <= rst_n;
end

// State and data storage
always @(posedge clk or negedge rst_n_sync) begin
    if (!rst_n_sync) begin
        has_first_byte <= 1'b0;
        first_byte_reg <= 8'b0;
    end else if (valid_in) begin
        if (!has_first_byte) begin
            first_byte_reg <= data_in;
            has_first_byte <= 1'b1;
        end else begin
            has_first_byte <= 1'b0;
        end
    end
end

// Output generation
always @(posedge clk or negedge rst_n_sync) begin
    if (!rst_n_sync) begin
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= next_valid_out;
        data_out <= next_data_out;
    end
end

// Next state logic
always @(*) begin
    next_valid_out = 1'b0;
    next_data_out = data_out;
    
    if (valid_in && has_first_byte) begin
        next_valid_out = 1'b1;
        next_data_out = {first_byte_reg, data_in};
    end
end

endmodule