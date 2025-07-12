module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [15:0] areg;         // multiplicand register
    reg [31:0] yout_r;       // product accumulator register
    reg [4:0]  i;            // shift count (0 to 16)
    reg        running;      // multiplication running flag

    // Shift count and running flag control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i       <= 5'd0;
            running <= 1'b0;
        end else begin
            if (start && !running) begin
                i       <= 5'd0;
                running <= 1'b1;
            end else if (running) begin
                if (i < 5'd16)
                    i <= i + 1'b1;
                else
                    running <= 1'b0; // done after 16 shifts
            end else begin
                i <= 5'd0;
            end
        end
    end

    // Registers update: areg, yout_r
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            yout_r <= 32'd0;
        end else begin
            if (start && !running) begin
                // Load multiplicand and multiplier at start
                areg   <= ain;
                yout_r <= {16'd0, bin};
            end else if (running && (i > 0 && i <= 16)) begin
                // If bit i-1 of multiplicand is set, accumulate shifted multiplier
                if (areg[i-1]) begin
                    yout_r <= yout_r + ({{16'd0, bin} << (i - 1)});
                end
            end else if (!running) begin
                // Keep output stable when not running
                yout_r <= yout_r;
            end
        end
    end

    // Done flag generation
    assign done = (running == 1'b0) && (i == 5'd16);

    // Output assignment
    assign yout = yout_r;

endmodule