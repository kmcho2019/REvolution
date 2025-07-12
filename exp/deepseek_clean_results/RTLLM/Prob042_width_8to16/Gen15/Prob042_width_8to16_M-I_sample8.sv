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
wire first_byte_ce = valid_in & !has_first_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_byte <= 1'b0;
        data_out <= 16'b0;
    end else begin
        if (valid_in) begin
            if (!has_first_byte) begin
                has_first_byte <= 1'b1;
            end else begin
                data_out <= {first_byte, data_in};
                has_first_byte <= 1'b0;
            end
        end
    end
end

// Clock-gated first byte register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        first_byte <= 8'b0;
    end else if (first_byte_ce) begin
        first_byte <= data_in;
    end
end

// Pipelined valid output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
    end else begin
        valid_out <= valid_in & has_first_byte;
    end
end

endmodule