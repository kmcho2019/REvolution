module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output wire [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] bit_counter;
    reg [7:0] shift_reg;
    reg load_output;

    // Shift register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
        end else if (din_valid) begin
            shift_reg <= {shift_reg[6:0], din_serial};  // LSB first shift
        end
    end

    // Counter and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_counter <= 3'b0;
            load_output <= 1'b0;
        end else begin
            load_output <= 1'b0;
            
            if (din_valid) begin
                if (bit_counter == 3'd7) begin
                    bit_counter <= 3'b0;
                    load_output <= 1'b1;
                end else begin
                    bit_counter <= bit_counter + 1'b1;
                end
            end
        end
    end

    // Output assignments
    assign dout_parallel = shift_reg;
    assign dout_valid = load_output;

endmodule