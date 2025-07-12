module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] buffer;
    reg [2:0] bit_count_gray;
    reg [1:0] valid_counter;
    wire [2:0] bit_count_binary;
    wire collecting;

    // Gray to binary conversion
    assign bit_count_binary = {bit_count_gray[2],
                              bit_count_gray[2] ^ bit_count_gray[1],
                              bit_count_gray[1] ^ bit_count_gray[0]};

    // Collection phase indicator (MSB of counter)
    assign collecting = ~bit_count_binary[2];

    // Clock gating for buffer register
    wire buffer_clk_en = din_valid & collecting;
    wire gated_clk = clk & buffer_clk_en;

    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
        end else begin
            buffer <= {buffer[6:0], din_serial};
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count_gray <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
            valid_counter <= 2'b0;
        end else begin
            // Gray counter increment
            if (din_valid) begin
                case (bit_count_gray)
                    3'b000: bit_count_gray <= 3'b001;
                    3'b001: bit_count_gray <= 3'b011;
                    3'b011: bit_count_gray <= 3'b010;
                    3'b010: bit_count_gray <= 3'b110;
                    3'b110: bit_count_gray <= 3'b111;
                    3'b111: bit_count_gray <= 3'b101;
                    3'b101: bit_count_gray <= 3'b100;
                    3'b100: bit_count_gray <= 3'b000;
                endcase
            end

            // Output handling
            if (bit_count_binary == 3'd0 && din_valid) begin
                dout_parallel <= buffer;
                valid_counter <= 2'b11; // Hold valid for 2 cycles
            end

            // Valid signal control
            dout_valid <= |valid_counter;
            if (valid_counter > 0) begin
                valid_counter <= valid_counter - 1'b1;
            end
        end
    end

endmodule