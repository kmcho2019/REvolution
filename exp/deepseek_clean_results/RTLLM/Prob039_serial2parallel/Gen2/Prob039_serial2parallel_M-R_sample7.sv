module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] cnt;          // 3-bit counter (0-7)
    reg [7:0] shift_reg;    // 8-bit shift register
    
    // Shift register implementation
    wire [7:0] next_shift = din_valid ? {shift_reg[6:0], din_serial} : shift_reg;
    
    // Counter implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
        end
        else if (din_valid) begin
            cnt <= (cnt == 3'd7) ? 3'b0 : cnt + 1'b1;
        end
    end
    
    // Shift register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
        end
        else begin
            shift_reg <= next_shift;
        end
    end
    
    // Parallel output capture
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
        end
        else if (din_valid && cnt == 3'd7) begin
            dout_parallel <= next_shift;
        end
    end
    
    // Output valid generation (combinational)
    assign dout_valid = (cnt == 3'd7) && din_valid;

endmodule