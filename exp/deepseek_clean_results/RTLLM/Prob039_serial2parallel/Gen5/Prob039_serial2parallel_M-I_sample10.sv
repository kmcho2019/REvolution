module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    parameter WIDTH = 8;
    
    reg [2:0] bit_pos;
    reg [WIDTH-1:0] shift_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_pos <= 3'b0;
            shift_reg <= {WIDTH{1'b0}};
            dout_valid <= 1'b0;
            dout_parallel <= {WIDTH{1'b0}};
        end
        else begin
            dout_valid <= 1'b0;  // Default
            
            if (din_valid) begin
                shift_reg <= {shift_reg[WIDTH-2:0], din_serial};
                
                if (bit_pos == WIDTH-1) begin
                    dout_parallel <= {shift_reg[WIDTH-2:0], din_serial};
                    dout_valid <= 1'b1;
                    bit_pos <= 3'b0;
                end
                else begin
                    bit_pos <= bit_pos + 1'b1;
                end
            end
        end
    end

endmodule