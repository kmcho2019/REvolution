module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] i;            // Reduced to 4-bit counter (0-15)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] yout_r;      // Product register
    reg done_r;             // Done flag register
    reg active;             // Active operation flag

    // Pre-compute all possible shifted versions
    wire [31:0] shifted [0:15];
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : shift_gen
            assign shifted[j] = {16'b0, breg} << j;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            i <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
            done_r <= 1'b0;
            active <= 1'b0;
        end else begin
            if (start && !active) begin
                // Start new multiplication
                areg <= ain;
                breg <= bin;
                yout_r <= 32'd0;
                done_r <= 1'b0;
                i <= 4'd0;
                active <= 1'b1;
            end else if (active) begin
                if (i < 4'd15) begin
                    // Shift-and-add operation using pre-shifted values
                    if (areg[i]) begin
                        yout_r <= yout_r + shifted[i];
                    end
                    i <= i + 1;
                end else begin
                    // Final iteration
                    if (areg[i]) begin
                        yout_r <= yout_r + shifted[i];
                    end
                    done_r <= 1'b1;
                    active <= 1'b0;
                end
            end else begin
                // Clear done flag when not active
                done_r <= 1'b0;
            end
        end
    end

    // Synchronous output assignments
    always @(posedge clk) begin
        if (done_r) begin
            yout <= yout_r;
        end
        done <= done_r;
    end

endmodule