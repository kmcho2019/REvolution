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
    reg [31:0] breg_shifted [15:0]; // Pre-shifted multiplier versions
    reg [31:0] yout_r;      // Product register
    wire running;           // Multiplication in progress

    assign running = start && (i < 4'd15);

    // Barrel shifter: pre-compute all shifted versions
    always @(*) begin
        for (integer j = 0; j < 16; j = j + 1) begin
            breg_shifted[j] = bin << j;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            i <= 4'd0;
            areg <= 16'd0;
            yout_r <= 32'd0;
            done <= 1'b0;
        end
        else begin
            // Control logic for iteration counter
            if (start) begin
                if (i == 4'd0) begin
                    // Load multiplicand at start
                    areg <= ain;
                    yout_r <= 32'd0;
                end
                
                if (running) begin
                    i <= i + 4'd1;
                end
            end
            else begin
                i <= 4'd0;
            end

            // Shift and accumulate operation
            if (running || (start && i == 4'd0)) begin
                if (areg[i]) begin
                    yout_r <= yout_r + breg_shifted[i];
                end
            end

            // Done flag generation (pipelined for better timing)
            done <= (i == 4'd15) && start;
        end
    end

    // Output assignments
    always @(*) begin
        yout = yout_r;
    end

endmodule