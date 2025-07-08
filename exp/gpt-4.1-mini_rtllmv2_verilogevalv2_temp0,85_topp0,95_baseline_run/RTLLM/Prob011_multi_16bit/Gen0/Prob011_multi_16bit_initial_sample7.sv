module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

// Shift count register: tracks multiplication progress from 0 to 17
reg [4:0] i;  // 5 bits to count up to 17

// Registers to hold multiplicand, multiplier, and product accumulation
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;

// Done flag register
reg done_r;

// Shift count register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'd0;
    end else begin
        if (start) begin
            if (i < 5'd17)
                i <= i + 5'd1;
        end else begin
            i <= 5'd0;
        end
    end
end

// Done flag update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 1'b0;
    end else begin
        if (i == 5'd16)
            done_r <= 1'b1;
        else if (i == 5'd17)
            done_r <= 1'b0;
    end
end

// Shift and accumulate operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg   <= 16'd0;
        breg   <= 16'd0;
        yout_r <= 32'd0;
    end else begin
        if (start) begin
            if (i == 5'd0) begin
                // Load multiplicand and multiplier at start
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end else if ((i > 5'd0) && (i < 5'd17)) begin
                // For bit i-1 of areg, if set, add breg shifted by i-1 to yout_r
                if (areg[i-1])
                    yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
            end
        end else begin
            // If start is not active, clear registers (optional, here we keep state)
            // But per spec, shift count resets, registers remain stable until start.
        end
    end
end

// Output assignments
assign yout = yout_r;
assign done = done_r;

endmodule