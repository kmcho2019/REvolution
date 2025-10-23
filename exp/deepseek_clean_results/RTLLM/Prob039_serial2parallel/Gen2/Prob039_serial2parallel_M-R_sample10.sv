module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    parameter WIDTH = 8;
    
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    
    // Continuous assignment for output valid
    assign dout_valid = (bit_cnt == WIDTH-1) && din_valid;
    
    // Shift register implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
        end
        else if (din_valid) begin
            shift_reg <= {shift_reg[6:0], din_serial};
        end
    end
    
    // Counter implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'b0;
        end
        else if (din_valid) begin
            bit_cnt <= (bit_cnt == WIDTH-1) ? 3'b0 : bit_cnt + 1'b1;
        end
    end
    
    // Parallel output capture
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
        end
        else if (dout_valid) begin
            dout_parallel <= shift_reg;
        end
    end

endmodule