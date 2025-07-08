module multi_16bit (
    input            clk,
    input            rst_n,
    input            start,
    input      [15:0] ain,
    input      [15:0] bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [4:0] i; // shift count register, needs to count up to 17
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] yout_r;
    reg done_r;

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

    // Multiplication completion flag generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            if (i == 16) begin
                done_r <= 1'b1;
            end else if (i == 17) begin
                done_r <= 1'b0;
            end
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
        end else begin
            if (start) begin
                if (i == 0) begin
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'b0;
                end else if ((i > 0) && (i < 17)) begin
                    if (areg[i-1]) begin
                        yout_r <= yout_r + ( {16'b0, breg} << (i-1) );
                    end
                end
            end else begin
                areg <= 16'b0;
                breg <= 16'b0;
                yout_r <= 32'b0;
            end
        end
    end

    // Output assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            yout <= yout_r;
            done <= done_r;
        end
    end

endmodule