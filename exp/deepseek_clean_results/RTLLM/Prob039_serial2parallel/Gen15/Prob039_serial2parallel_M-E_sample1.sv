module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output wire [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] bit_counter;
    reg din_valid_delayed;

    // Shift register and counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            bit_counter <= 3'b0;
            din_valid_delayed <= 1'b0;
        end else begin
            din_valid_delayed <= din_valid;
            
            if (din_valid) begin
                // Right shift with new bit inserted at MSB
                shift_reg <= {din_serial, shift_reg[7:1]};
                
                if (bit_counter == 3'd7) begin
                    bit_counter <= 3'b0;
                end else begin
                    bit_counter <= bit_counter + 1'b1;
                end
            end
        end
    end

    // Output is always the current shift register value
    assign dout_parallel = shift_reg;

    // Valid pulse generation (one cycle after last bit is shifted in)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= (bit_counter == 3'd7) && din_valid && !din_valid_delayed;
        end
    end

endmodule