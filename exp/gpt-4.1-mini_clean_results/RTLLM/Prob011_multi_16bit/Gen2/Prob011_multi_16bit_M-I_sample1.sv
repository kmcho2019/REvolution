module multi_16bit (
    input         clk,
    input         rst_n,
    input         start,
    input  [15:0] ain,
    input  [15:0] bin,
    output reg [31:0] yout,
    output reg        done
);

    reg [4:0] i;           // Shift count (0 to 16)
    reg [31:0] areg;       // Multiplicand register, zero-extended
    reg [15:0] breg;       // Multiplier register (shifted right each cycle)
    reg [31:0] yout_r;     // Product accumulator
    reg done_r;            // Internal done flag

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (start) begin
            if (i < 5'd16)
                i <= i + 5'd1;
            else
                i <= i; // Hold at 16
        end else
            i <= 5'd0;
    end

    // Multiplication completion flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (!start)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 32'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load multiplicand zero-extended and multiplier, clear accumulator
                areg   <= {16'd0, ain};
                breg   <= bin;
                yout_r <= 32'd0;
            end else if (i <= 5'd16) begin
                // If LSB of breg is 1, add areg to yout_r
                if (breg[0])
                    yout_r <= yout_r + areg;
                // Shift areg left by 1 and breg right by 1 for next bit
                areg <= areg << 1;
                breg <= breg >> 1;
            end
        end
    end

    // Output assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 32'd0;
            done <= 1'b0;
        end else begin
            yout <= yout_r;
            done <= done_r;
        end
    end

endmodule