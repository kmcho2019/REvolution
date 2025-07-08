module multi_16bit (
    input             clk,
    input             rst_n,
    input             start,
    input      [15:0] ain,
    input      [15:0] bin,
    output reg [31:0] yout,
    output reg        done
);

    reg [4:0]  i;       // shift count: needs 5 bits to cover 0 to 17
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] yout_r;
    reg        done_r;

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 0;
        else if (start) begin
            if (i < 17)
                i <= i + 1;
        end else
            i <= 0;
    end

    // Done flag generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 16)
            done_r <= 1'b1;
        else if (i == 17)
            done_r <= 1'b0;
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'b0;
            breg   <= 16'b0;
            yout_r <= 32'b0;
        end else if (start) begin
            if (i == 0) begin
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'b0;
            end else if ((i > 0) && (i < 17)) begin
                if (areg[i-1]) begin
                    // accumulate shifted breg at position i-1
                    yout_r <= yout_r + ({16'b0, breg} << (i - 1));
                end
            end
        end
    end

    // Output assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            yout <= 32'b0;
        else
            yout <= yout_r;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done <= 1'b0;
        else
            done <= done_r;
    end

endmodule