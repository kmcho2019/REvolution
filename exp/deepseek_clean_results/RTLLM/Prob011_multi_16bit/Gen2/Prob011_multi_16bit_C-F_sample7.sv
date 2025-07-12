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
    reg [31:0] breg_ext;    // Extended multiplier register (for shifting)
    reg [31:0] yout_r;      // Product register
    reg running;            // Operation in progress flag

    // Barrel shifter for multiplier
    wire [31:0] shifted_b = breg_ext << i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            i <= 4'd0;
            areg <= 16'd0;
            breg_ext <= 32'd0;
            yout_r <= 32'd0;
            done <= 1'b0;
            running <= 1'b0;
        end
        else begin
            // Control logic
            if (start && !running) begin
                // Start new multiplication
                areg <= ain;
                breg_ext <= {16'd0, bin};
                yout_r <= 32'd0;
                i <= 4'd0;
                running <= 1'b1;
                done <= 1'b0;
            end
            else if (running) begin
                if (i < 4'd15) begin
                    // Shift-and-accumulate operation
                    if (areg[i]) begin
                        yout_r <= yout_r + shifted_b;
                    end
                    i <= i + 4'd1;
                end
                else begin
                    // Final accumulation and completion
                    if (areg[i]) begin
                        yout_r <= yout_r + shifted_b;
                    end
                    running <= 1'b0;
                    done <= 1'b1;
                end
            end
            else begin
                // Idle state
                done <= 1'b0;
            end
        end
    end

    // Output assignments
    always @(*) begin
        yout = yout_r;
    end

endmodule