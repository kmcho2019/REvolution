module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] bit_pos;
    
    // Next bit position calculation
    wire [2:0] next_bit_pos = (!rst_n) ? 3'b0 :
                             (din_valid && (bit_pos == 3'd7)) ? 3'b0 :
                             din_valid ? (bit_pos + 1'b1) :
                             bit_pos;
    
    // Shift register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            bit_pos <= 3'b0;
        end
        else if (din_valid) begin
            shift_reg <= {shift_reg[6:0], din_serial};
            bit_pos <= next_bit_pos;
        end
    end
    
    // Parallel output capture
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
        end
        else if (din_valid && (bit_pos == 3'd7)) begin
            dout_parallel <= {shift_reg[6:0], din_serial};
        end
    end
    
    // Combinational valid output
    assign dout_valid = din_valid && (bit_pos == 3'd7);

endmodule