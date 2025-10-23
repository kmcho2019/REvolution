module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    parameter WIDTH = 8;
    
    reg [7:0] buffer;
    reg [2:0] bit_count_gray;
    reg [2:0] bit_count_bin;
    reg       valid_pulse;
    
    // Gray to binary conversion
    always @(*) begin
        bit_count_bin[2] = bit_count_gray[2];
        bit_count_bin[1] = bit_count_gray[2] ^ bit_count_gray[1];
        bit_count_bin[0] = bit_count_gray[2] ^ bit_count_gray[1] ^ bit_count_gray[0];
    end
    
    // Continuous assignment for output valid
    assign dout_valid = valid_pulse;
    
    // Main processing logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= {WIDTH{1'b0}};
            dout_parallel <= {WIDTH{1'b0}};
            bit_count_gray <= 3'b0;
            valid_pulse <= 1'b0;
        end
        else begin
            valid_pulse <= 1'b0;  // Default
            
            if (din_valid) begin
                buffer <= {buffer[WIDTH-2:0], din_serial};
                
                // Gray counter increment
                case (bit_count_gray)
                    3'b000: bit_count_gray <= 3'b001;
                    3'b001: bit_count_gray <= 3'b011;
                    3'b011: bit_count_gray <= 3'b010;
                    3'b010: bit_count_gray <= 3'b110;
                    3'b110: bit_count_gray <= 3'b111;
                    3'b111: bit_count_gray <= 3'b101;
                    3'b101: bit_count_gray <= 3'b100;
                    3'b100: begin
                        bit_count_gray <= 3'b000;
                        dout_parallel <= buffer;
                        valid_pulse <= 1'b1;
                    end
                endcase
            end
        end
    end

endmodule