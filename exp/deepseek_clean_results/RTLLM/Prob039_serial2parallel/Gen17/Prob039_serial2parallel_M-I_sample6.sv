module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] buffer;
    reg [3:0] gray_count; // Gray coded counter (1 extra bit for implicit state)
    wire [3:0] next_gray;
    wire buffer_clk_en;
    reg dout_valid_d;

    // Gray code increment
    assign next_gray = gray_count + {3'b0, (din_valid & ~gray_count[3])};

    // Clock enable for buffer (only when collecting bits)
    assign buffer_clk_en = din_valid & ~gray_count[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
            dout_parallel <= 8'b0;
            gray_count <= 4'b0;
            dout_valid <= 1'b0;
            dout_valid_d <= 1'b0;
        end
        else begin
            // Gray counter update
            gray_count <= next_gray;

            // Buffer collection (pipelined shift)
            if (buffer_clk_en) begin
                if (~gray_count[0]) begin
                    buffer[7:4] <= {buffer[6:4], din_serial};
                end
                else begin
                    buffer[3:0] <= {buffer[2:0], din_serial};
                end
            end

            // Output generation
            if (gray_count == 4'b1000) begin
                dout_parallel <= buffer;
                gray_count <= 4'b0;
            end

            // Extended valid signal (2 cycles)
            dout_valid <= (gray_count == 4'b1000) | dout_valid_d;
            dout_valid_d <= (gray_count == 4'b1000);
        end
    end

endmodule