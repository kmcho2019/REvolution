module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first_half;
reg [7:0] first_half;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_half <= 1'b0;
        first_half <= 8'b0;
        data_out <= 16'b0;
    end
    else begin
        if (valid_in) begin
            if (has_first_half) begin
                data_out <= {first_half, data_in};
                has_first_half <= 1'b0;
            end
            else begin
                first_half <= data_in;
                has_first_half <= 1'b1;
            end
        end
    end
end

always @(*) begin
    valid_out = valid_in && has_first_half;
end

endmodule