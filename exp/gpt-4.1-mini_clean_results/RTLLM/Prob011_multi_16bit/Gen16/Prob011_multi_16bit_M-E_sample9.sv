module multi_16bit (
    input         clk,
    input         rst_n,
    input         start,
    input  [15:0] ain,
    input  [15:0] bin,
    output [31:0] yout,
    output        done
);

    reg [4:0]  i;          // shift count: 0..16 active, else idle
    reg [15:0] areg;       // multiplicand register
    reg [15:0] breg;       // multiplier register (shifted right each cycle)
    reg [31:0] product;    // product accumulator
    reg        done_r;

    // Shift count logic and done flag generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            done_r <= 1'b0;
        end else begin
            if (!start) begin
                i      <= 5'd0;
                done_r <= 1'b0;
            end else if (i < 5'd16) begin
                i <= i + 5'd1;
                if (i == 5'd15) // After 16 cycles done (i from 1 to 16)
                    done_r <= 1'b1;
            end
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            breg    <= 16'd0;
            product <= 32'd0;
        end else begin
            if (start && i == 5'd0) begin
                // Load inputs at start
                areg    <= ain;
                breg    <= bin;
                product <= 32'd0;
            end else if (start && (i > 5'd0) && (i <= 5'd16)) begin
                // If LSB of multiplier is 1, add multiplicand shifted by i-1 to product
                if (breg[0])
                    product <= product + ( {16'd0, areg} << (i - 1) );
                else
                    product <= product;
                breg <= breg >> 1; // Shift multiplier right each cycle
            end else if (!start) begin
                // Reset registers when not started
                areg    <= 16'd0;
                breg    <= 16'd0;
                product <= 32'd0;
            end
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule