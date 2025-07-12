module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    localparam IDLE     = 5'd0;
    localparam MAX_COUNT= 5'd16;  // Number of shift/add cycles

    reg [4:0]  i;           // shift count: 0 to 17
    reg [31:0] multiplicand; // 32-bit multiplicand register, shifts left
    reg [15:0] multiplier;   // 16-bit multiplier register, shifts right
    reg [31:0] accumulator;  // current product register

    reg [31:0] adder_out;    // registered adder output (pipeline stage)

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= IDLE;
        else if (!start)
            i <= IDLE;
        else if (i < (MAX_COUNT + 1))
            i <= i + 5'd1;
    end

    // Multiplicand, multiplier, and accumulator update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 32'd0;
            multiplier   <= 16'd0;
            accumulator  <= 32'd0;
            adder_out    <= 32'd0;
        end else if (start) begin
            if (i == IDLE) begin
                // Load inputs at cycle 0
                multiplicand <= {16'd0, ain};
                multiplier   <= bin;
                accumulator  <= 32'd0;
                adder_out    <= 32'd0;
            end else if (i <= MAX_COUNT) begin
                // Shift & Add stage (adder_out pipelined)
                // Update accumulator from previous adder_out
                accumulator <= adder_out;

                // Compute next adder_out based on current multiplier LSB
                if (multiplier[0])
                    adder_out <= accumulator + multiplicand;
                else
                    adder_out <= accumulator;

                multiplicand <= multiplicand << 1;
                multiplier   <= multiplier >> 1;
            end else begin
                // After multiplication complete, hold registers
                accumulator <= accumulator;
                adder_out   <= adder_out;
                multiplicand <= multiplicand;
                multiplier   <= multiplier;
            end
        end else begin
            // When start is low, hold values (no reset)
            accumulator  <= accumulator;
            adder_out    <= adder_out;
            multiplicand <= multiplicand;
            multiplier   <= multiplier;
        end
    end

    // Done signal combinational from counter
    assign done = (i == MAX_COUNT);

    assign yout = accumulator;

endmodule