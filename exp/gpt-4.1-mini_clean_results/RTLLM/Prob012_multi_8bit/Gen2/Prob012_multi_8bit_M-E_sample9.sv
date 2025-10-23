module multi_8bit (
    input           clk,
    input           rst_n,
    input           start,
    input  [7:0]    A,
    input  [7:0]    B,
    output reg [15:0] product,
    output reg      ready
);

    reg [15:0] multiplicand; // shifted A
    reg [7:0]  multiplier;
    reg [3:0]  count;
    reg [15:0] accumulator;
    reg        running;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator   <= 16'b0;
            multiplicand  <= 16'b0;
            multiplier    <= 8'b0;
            count         <= 4'd0;
            product       <= 16'b0;
            ready         <= 1'b0;
            running       <= 1'b0;
        end else begin
            if (start && !running) begin
                // Initialize on start
                multiplicand  <= {8'b0, A}; // align multiplicand in lower 8 bits
                multiplier    <= B;
                accumulator   <= 16'b0;
                count         <= 4'd0;
                ready         <= 1'b0;
                running       <= 1'b1;
            end else if (running) begin
                if (multiplier[0]) begin
                    accumulator <= accumulator + multiplicand;
                end
                multiplicand <= multiplicand << 1;
                multiplier   <= multiplier >> 1;
                count       <= count + 1;

                if (count == 4'd7) begin
                    product <= accumulator;
                    ready   <= 1'b1;
                    running <= 1'b0;
                end
            end else begin
                ready <= 1'b0;
            end
        end
    end

endmodule