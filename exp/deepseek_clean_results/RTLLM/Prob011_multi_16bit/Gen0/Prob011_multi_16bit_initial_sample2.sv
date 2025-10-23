module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [4:0] i;            // Shift counter (0-17)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] yout_r;      // Product register
    reg done_r;             // Done flag register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            i <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
            done_r <= 1'b0;
        end
        else begin
            // Control logic for iteration counter
            if (!start) begin
                i <= 5'd0;
            end
            else if (i < 5'd17) begin
                i <= i + 5'd1;
            end

            // Shift and accumulate operation
            if (start) begin
                if (i == 5'd0) begin
                    // Load operands at start
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'd0;
                end
                else if (i < 5'd17) begin
                    // Check current bit and accumulate if set
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                end
            end
            else begin
                yout_r <= 32'd0;
            end

            // Done flag generation
            if (i == 5'd16) begin
                done_r <= 1'b1;
            end
            else if (i == 5'd17) begin
                done_r <= 1'b0;
            end
            else begin
                done_r <= 1'b0;
            end
        end
    end

    // Output assignments
    always @(*) begin
        yout = yout_r;
        done = done_r;
    end

endmodule