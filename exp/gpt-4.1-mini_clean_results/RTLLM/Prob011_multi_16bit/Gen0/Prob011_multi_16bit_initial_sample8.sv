module multi_16bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [15:0] ain,
    input  wire [15:0] bin,
    output reg  [31:0] yout,
    output reg         done
);

    reg [4:0] i;            // shift count: 0..16 (need 5 bits)
    reg [15:0] areg;        // multiplicand register
    reg [15:0] breg;        // multiplier register
    reg [31:0] yout_r;      // product register
    reg        done_r;      // internal done flag

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 0;
        end else begin
            if (!start) begin
                i <= 0;
            end else if (i < 17) begin
                i <= i + 1;
            end
        end
    end

    // Done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            if (i == 16)
                done_r <= 1'b1;
            else if (i == 17)
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
            if (i == 0) begin
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end else if (i > 0 && i < 17) begin
                // Check bit i-1 of areg
                if (areg[i-1]) begin
                    yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
                end
                // else no addition, just keep yout_r unchanged
            end
        end else begin
            // If start is low, clear registers as we want to be ready for next start
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end
    end

    // Output assignment
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