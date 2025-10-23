module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output wire [7:0] dout_parallel,
    output wire dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg valid_reg;

    // Shift register and counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            bit_count <= 3'b0;
            valid_reg <= 1'b0;
        end else begin
            if (din_valid) begin
                shift_reg <= {shift_reg[6:0], din_serial};
                
                if (bit_count == 3'd7) begin
                    bit_count <= 3'b0;
                    valid_reg <= 1'b1;
                end else begin
                    bit_count <= bit_count + 1'b1;
                    valid_reg <= 1'b0;
                end
            end else begin
                valid_reg <= 1'b0;
            end
        end
    end

    // Output assignments
    assign dout_parallel = shift_reg;
    assign dout_valid = valid_reg;

endmodule