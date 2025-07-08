module multi_16bit (
    input         clk,
    input         rst_n,
    input         start,
    input  [15:0] ain,
    input  [15:0] bin,
    output [31:0] yout,
    output        done
);

    reg [4:0]  i;        // shift count register: needs 5 bits to count up to 17
    reg [15:0] areg;     // multiplicand register
    reg [15:0] breg;     // multiplier register
    reg [31:0] yout_r;   // product register
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

    // Multiplication done flag generation
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
            end else if (i > 0 && i < 17) begin
                // Check bit i-1 of multiplicand
                if (areg[i-1])
                    yout_r <= yout_r + ({16'b0, breg} << (i-1));
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule