module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt_gray;  // Gray coded counter
    reg [7:0] shift_reg;

    // Gray to binary conversion for comparison
    wire [2:0] cnt_binary = {cnt_gray[2],
                            cnt_gray[2] ^ cnt_gray[1],
                            cnt_gray[2] ^ cnt_gray[1] ^ cnt_gray[0]};

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt_gray <= 3'b000;
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default to 0
            
            if (din_valid) begin
                // Bit-wise assignment instead of shift
                case (cnt_binary)
                    3'd0: shift_reg[7] <= din_serial;
                    3'd1: shift_reg[6] <= din_serial;
                    3'd2: shift_reg[5] <= din_serial;
                    3'd3: shift_reg[4] <= din_serial;
                    3'd4: shift_reg[3] <= din_serial;
                    3'd5: shift_reg[2] <= din_serial;
                    3'd6: shift_reg[1] <= din_serial;
                    3'd7: shift_reg[0] <= din_serial;
                endcase

                // Gray counter increment
                case (cnt_gray)
                    3'b000: cnt_gray <= 3'b001;
                    3'b001: cnt_gray <= 3'b011;
                    3'b011: cnt_gray <= 3'b010;
                    3'b010: cnt_gray <= 3'b110;
                    3'b110: cnt_gray <= 3'b111;
                    3'b111: cnt_gray <= 3'b101;
                    3'b101: cnt_gray <= 3'b100;
                    3'b100: cnt_gray <= 3'b000;
                endcase

                // Output when complete
                if (cnt_binary == 3'd7) begin
                    dout_parallel <= shift_reg;
                    dout_valid <= 1'b1;
                end
            end
        end
    end

endmodule