module multi_16bit (
    input           clk,
    input           rst_n,
    input           start,
    input   [15:0]  ain,
    input   [15:0]  bin,
    output  [31:0]  yout,
    output          done
);

    reg [4:0]   i;          // shift count register: 0..17 to control operation
    reg [15:0]  areg;       // multiplicand register
    reg [15:0]  breg;       // multiplier register
    reg [31:0]  yout_r;     // product register
    reg         done_r;     // done flag register

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (start && i < 5'd17) begin
            i <= i + 5'd1;
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
        end else if (start) begin
            if (i == 5'd0) begin
                // Load multiplicand and multiplier registers at start
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end else if ((i > 5'd0) && (i < 5'd17)) begin
                // Check bit (i-1) of multiplicand and accumulate if set
                if (areg[i-1])
                    yout_r <= yout_r + ( {16'd0, breg} << (i - 1) );
            end
            // When i == 17, hold results, no operation
        end else begin
            // If start deasserted, clear registers
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end
    end

    // Output assignments
    assign yout = yout_r;
    assign done = done_r;

endmodule