module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output wire [15:0] count
);

reg [7:0] low_byte;
reg [7:0] high_byte;

always @(posedge clk) begin
    if (reset) begin
        low_byte  <= 8'd0;
        high_byte <= 8'd0;
    end else begin
        if (up_down) begin
            // Increment low byte, check overflow
            if (low_byte == 8'hFF) begin
                low_byte  <= 8'd0;
                high_byte <= high_byte + 8'd1;
            end else begin
                low_byte <= low_byte + 8'd1;
            end
        end else begin
            // Decrement low byte, check underflow
            if (low_byte == 8'd0) begin
                low_byte  <= 8'hFF;
                high_byte <= high_byte - 8'd1;
            end else begin
                low_byte <= low_byte - 8'd1;
            end
        end
    end
end

assign count = {high_byte, low_byte};

endmodule