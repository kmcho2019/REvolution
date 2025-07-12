module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] shift_reg;
    wire shift_complete = shift_reg[0];  // LSB indicates when 8 bits are collected

    // Shift register logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b1000_0000;  // Start with MSB set
        end
        else if (din_valid) begin
            shift_reg <= {shift_reg[6:0], din_serial};
        end
    end

    // Output and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default assignment
            
            if (din_valid && shift_complete) begin
                dout_parallel <= {shift_reg[7:1], din_serial};  // Capture all 8 bits
                dout_valid <= 1'b1;
            end
        end
    end

endmodule