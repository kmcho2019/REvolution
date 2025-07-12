module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Pipeline registers
reg [7:0] first_byte;
reg has_first_byte;
reg [7:0] second_byte;
reg has_second_byte;

// Pipeline stage 1: Capture first byte
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        first_byte <= 8'b0;
        has_first_byte <= 1'b0;
    end else if (valid_in && !has_first_byte) begin
        first_byte <= data_in;
        has_first_byte <= 1'b1;
    end
end

// Pipeline stage 2: Capture second byte and prepare output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        second_byte <= 8'b0;
        has_second_byte <= 1'b0;
    end else if (valid_in && has_first_byte) begin
        second_byte <= data_in;
        has_second_byte <= 1'b1;
    end
end

// Output stage: Register final output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= has_second_byte;
        if (has_second_byte) begin
            data_out <= {first_byte, second_byte};
            // Reset pipeline for next pair
            has_first_byte <= 1'b0;
            has_second_byte <= 1'b0;
        end
    end
end

endmodule