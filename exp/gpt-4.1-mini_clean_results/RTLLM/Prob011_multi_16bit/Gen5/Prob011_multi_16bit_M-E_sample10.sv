module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]     i;           // shift count: 0 to 17
    reg           done_r;
    reg [31:0]    multiplicand; // 32-bit multiplicand register, shifts left
    reg [15:0]    multiplier;   // 16-bit multiplier register, shifts right
    reg [31:0]    accumulator;  // accumulation register

    // Shift count update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (!start)
            i <= 5'd0;
        else if (i < 5'd17)
            i <= i + 5'd1;
    end

    // Done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
        else if (i == 5'd17)
            done_r <= 1'b0;
    end

    // Main multiply shift-and-add logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 32'd0;
            multiplier   <= 16'd0;
            accumulator  <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load multiplicand and multiplier at start
                multiplicand <= {16'd0, ain}; // multiplicand in lower 16 bits
                multiplier   <= bin;
                accumulator  <= 32'd0;
            end else if (i <= 5'd16) begin
                // During shift-add cycles
                if (multiplier[0])
                    accumulator <= accumulator + multiplicand;

                multiplicand <= multiplicand << 1;
                multiplier   <= multiplier >> 1;
            end else begin
                // Hold values at i == 17 or beyond
                multiplicand <= multiplicand;
                multiplier   <= multiplier;
                accumulator  <= accumulator;
            end
        end else begin
            // Reset registers if not started
            multiplicand <= 32'd0;
            multiplier   <= 16'd0;
            accumulator  <= 32'd0;
        end
    end

    assign yout = accumulator;
    assign done = done_r;

endmodule