module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [4:0] i;            // Shift count (0 to 16)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier shift register
    reg [31:0] acc;         // Accumulator for product

    // Shift count update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (start && i < 5'd17) begin
            i <= i + 5'd1;
        end
    end

    // Done flag generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 1'b0;
        end else if (i == 5'd16) begin
            done <= 1'b1;
        end else if (i == 5'd17) begin
            done <= 1'b0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'd0;
            breg <= 16'd0;
            acc  <= 32'd0;
            yout <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                areg <= ain;
                breg <= bin;
                acc  <= 32'd0;
                yout <= 32'd0;
            end else if (i > 5'd0 && i < 5'd17) begin
                // If LSB of multiplier is 1, add multiplicand shifted by (i-1) to acc
                if (breg[0]) begin
                    acc <= acc + ({{16{1'b0}}, areg} << (i-1));
                end else begin
                    acc <= acc;
                end
                breg <= breg >> 1;
                yout <= acc;  // Update output each cycle to reflect latest partial product
            end else begin
                // i == 17, hold product stable
                yout <= acc;
            end
        end else begin
            // start inactive, clear registers and output
            areg <= 16'd0;
            breg <= 16'd0;
            acc  <= 32'd0;
            yout <= 32'd0;
        end
    end

endmodule