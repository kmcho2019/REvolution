module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] i;            // Shift counter (0-15)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] yout_r;      // Product register
    reg running;            // Multiplication active flag

    // Pre-compute all possible shifted versions
    wire [31:0] shifted_b [15:0];
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : shift_gen
            assign shifted_b[k] = {16'b0, breg} << k;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            i <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
            done <= 1'b0;
            running <= 1'b0;
        end
        else begin
            // Control logic
            if (start && !running) begin
                // Start new multiplication
                areg <= ain;
                breg <= bin;
                yout_r <= 32'd0;
                i <= 4'd0;
                running <= 1'b1;
                done <= 1'b0;
            end
            else if (running) begin
                if (i < 15) begin
                    // Processing cycles
                    if (areg[i]) begin
                        yout_r <= yout_r + shifted_b[i];
                    end
                    i <= i + 1;
                end
                else begin
                    // Final cycle (i=15)
                    if (areg[15]) begin
                        yout_r <= yout_r + shifted_b[15];
                    end
                    done <= 1'b1;
                    running <= 1'b0;
                end
            end
            else begin
                done <= 1'b0;
            end
        end
    end

    // Registered output
    always @(posedge clk) begin
        if (done) begin
            yout <= yout_r;
        end
    end

endmodule