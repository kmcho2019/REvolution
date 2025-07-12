module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] i;            // Shift counter (0-16)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] yout_r;      // Product register
    wire [31:0] shifted_b;  // Pre-computed shifted version

    // Pre-compute all possible shifted versions
    assign shifted_b = breg << i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            i <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
            done <= 1'b0;
        end
        else begin
            if (start) begin
                if (i == 4'd0) begin
                    // Initialization cycle
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'd0;
                    done <= 1'b0;
                    i <= i + 1;
                end
                else if (i < 4'd16) begin
                    // Processing cycles
                    if (areg[i-1]) begin
                        yout_r <= yout_r + shifted_b;
                    end
                    i <= i + 1;
                end
                else begin
                    // Multiplication complete
                    done <= 1'b1;
                end
            end
            else begin
                // Start not asserted, reset counter
                i <= 4'd0;
                done <= 1'b0;
            end
        end
    end

    // Registered output assignment
    always @(posedge clk) begin
        yout <= yout_r;
    end

endmodule