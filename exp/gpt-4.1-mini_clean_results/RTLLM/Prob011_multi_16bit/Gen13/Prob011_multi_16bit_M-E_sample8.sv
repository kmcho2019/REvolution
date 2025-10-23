module multi_16bit (
    input         clk,
    input         rst_n,
    input         start,
    input  [15:0] ain,
    input  [15:0] bin,
    output [31:0] yout,
    output        done
);

    reg [4:0]  i;          // Shift/count register: 0..17 (needs 5 bits)
    reg [15:0] areg;       // Multiplicand register
    reg [15:0] breg;       // Multiplier register
    reg [31:0] yout_r;     // Product accumulator register
    reg        done_r;     // Done flag register

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (i < 5'd17) begin
            i <= i + 5'd1;
        end
    end

    // Done flag generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            if (i == 5'd16) begin
                done_r <= 1'b1;
            end else if (i == 5'd17) begin
                done_r <= 1'b0;
            end
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
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end else if ((i > 5'd0) && (i < 5'd17)) begin
                // Check bit (i-1) of areg, if 1 accumulate shifted breg
                if (areg[i-1]) begin
                    yout_r <= yout_r + ({16'd0, breg} << (i-1));
                end
            end
        end else begin
            // When start is inactive, reset product register
            yout_r <= 32'd0;
        end
    end

    assign done = done_r;
    assign yout = yout_r;

endmodule