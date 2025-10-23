module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output wire [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    assign dout_parallel = shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;
            
            if (din_valid) begin
                shift_reg <= {shift_reg[6:0], din_serial};
                
                if (bit_count == 3'd7) begin
                    dout_valid <= 1'b1;
                    bit_count <= 3'b0;
                end
                else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end
    end

endmodule