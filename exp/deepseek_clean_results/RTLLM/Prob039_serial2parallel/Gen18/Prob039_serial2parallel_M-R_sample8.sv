module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    wire counter_full;

    // Continuous assignment for valid signal
    assign dout_valid = counter_full & din_valid;
    assign counter_full = (bit_count == 3'd7);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            bit_count <= 3'b0;
            dout_parallel <= 8'b0;
        end
        else begin
            if (din_valid) begin
                // Shift in new bit
                shift_reg <= {shift_reg[6:0], din_serial};
                
                // Update counter
                if (counter_full) begin
                    bit_count <= 3'b0;
                    // Capture parallel output when full
                    dout_parallel <= {shift_reg[6:0], din_serial};
                end
                else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end
    end

endmodule