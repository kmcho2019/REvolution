module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    parameter WIDTH = 8;
    
    reg [2:0] bit_pos;
    reg [7:0] shift_reg;
    
    // Combinational valid signal
    assign dout_valid = (bit_pos == WIDTH-1) & din_valid;
    
    // Shift register and counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_pos <= 3'b0;
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
        end
        else if (din_valid) begin
            shift_reg <= {shift_reg[6:0], din_serial};
            
            if (bit_pos == WIDTH-1) begin
                bit_pos <= 3'b0;
                dout_parallel <= {shift_reg[6:0], din_serial}; // Capture before shift
            end
            else begin
                bit_pos <= bit_pos + 1'b1;
            end
        end
    end

endmodule