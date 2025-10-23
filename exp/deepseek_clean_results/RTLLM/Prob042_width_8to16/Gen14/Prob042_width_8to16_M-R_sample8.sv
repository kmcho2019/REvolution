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

// Data capture and control logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_byte <= 1'b0;
        first_byte <= 8'b0;
    end else if (valid_in) begin
        if (!has_first_byte) begin
            first_byte <= data_in;
            has_first_byte <= 1'b1;
        end else begin
            has_first_byte <= 1'b0;
        end
    end
end

// Output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= valid_in && has_first_byte;
        if (valid_in && has_first_byte) begin
            data_out <= {first_byte, data_in};
        end
    end
end

endmodule