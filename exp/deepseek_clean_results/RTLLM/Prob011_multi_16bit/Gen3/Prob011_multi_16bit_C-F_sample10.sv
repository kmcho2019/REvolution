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
    reg running;            // Operation in progress flag
    
    // Barrel shifter outputs
    wire [31:0] shifted_b = {16'b0, breg} << i;

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
            // Default assignments
            done <= 1'b0;
            
            // State machine
            if (!running) begin
                // Idle state
                if (start) begin
                    // Start new multiplication
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'd0;
                    i <= 4'd0;
                    running <= 1'b1;
                end
            end
            else begin
                // Running state
                if (i < 4'd15) begin
                    // Normal operation
                    if (areg[i]) begin
                        yout_r <= yout_r + shifted_b;
                    end
                    i <= i + 4'd1;
                end
                else begin
                    // Final cycle
                    if (areg[i]) begin
                        yout_r <= yout_r + shifted_b;
                    end
                    running <= 1'b0;
                    done <= 1'b1;
                end
            end
        end
    end

    // Continuous output assignment
    always @(*) begin
        yout = yout_r;
    end

endmodule