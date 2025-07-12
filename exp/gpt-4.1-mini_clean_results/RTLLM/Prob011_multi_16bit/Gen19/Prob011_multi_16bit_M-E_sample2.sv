module multi_16bit (
    input           clk,
    input           rst_n,
    input           start,
    input  [15:0]   ain,    // multiplicand
    input  [15:0]   bin,    // multiplier
    output [31:0]   yout,
    output          done
);

    reg [31:0] accumulator;   // upper 32 bits of combined reg (partial product)
    reg [15:0] multiplier;    // lower 16 bits of combined reg (shifting multiplier)
    reg [15:0] multiplicand;  // fixed multiplicand
    reg [4:0]  count;         // shift count: from 0 to 16
    reg        busy;          // multiplication in progress

    // Control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator  <= 32'd0;
            multiplier   <= 16'd0;
            multiplicand <= 16'd0;
            count        <= 5'd0;
            busy         <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Load inputs, start multiplication
                multiplicand <= ain;
                multiplier   <= bin;
                accumulator  <= 32'd0;
                count        <= 5'd0;
                busy         <= 1'b1;
            end else if (busy) begin
                // Multiply step
                if (multiplier[0] == 1'b1) begin
                    // Add multiplicand to accumulator
                    accumulator <= accumulator + {16'd0, multiplicand};
                end else begin
                    accumulator <= accumulator;
                end
                // Shift combined accumulator and multiplier right by 1
                // concatenated as {accumulator, multiplier}
                {accumulator, multiplier} <= {1'b0, accumulator, multiplier} >> 1;
                // increment count
                count <= count + 5'd1;
                // Finish multiplication after 16 cycles
                if (count == 5'd15) begin
                    busy <= 1'b0;
                end
            end
        end
    end

    assign done = (busy == 1'b0) && (count == 5'd16);

    assign yout = accumulator;

endmodule