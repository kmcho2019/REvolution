module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] product,
    output reg         ready
);

    reg [15:0] multiplicand;
    reg [7:0]  multiplier;
    reg [15:0] accumulator;
    reg [3:0]  bit_index;
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product      <= 16'd0;
            multiplicand <= 16'd0;
            multiplier   <= 8'd0;
            accumulator  <= 16'd0;
            bit_index    <= 4'd0;
            ready        <= 1'b0;
            busy         <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Load inputs and initialize
                multiplicand <= {8'd0, A};  // Extend A to 16 bits
                multiplier   <= B;
                accumulator  <= 16'd0;
                bit_index    <= 4'd0;
                ready        <= 1'b0;
                busy         <= 1'b1;
            end else if (busy) begin
                // Shift-and-add iteration
                if (multiplier[0] == 1'b1) begin
                    accumulator <= accumulator + multiplicand;
                end
                multiplicand <= multiplicand << 1;
                multiplier   <= multiplier >> 1;
                bit_index    <= bit_index + 1;

                if (bit_index == 4'd7) begin
                    product <= accumulator;
                    ready   <= 1'b1;
                    busy    <= 1'b0;
                end
            end else begin
                ready <= 1'b0; // Clear ready when not busy and no new start
            end
        end
    end

endmodule