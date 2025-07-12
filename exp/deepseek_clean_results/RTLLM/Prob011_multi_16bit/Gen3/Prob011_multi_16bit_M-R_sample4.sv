module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] areg;
    reg [31:0] breg_shifted [0:15]; // Pre-shifted multiplier values
    reg [31:0] acc;
    reg [3:0] cycle; // 4-bit counter (0-15)
    reg running;

    // Pre-shift the multiplier at start
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer j = 0; j < 16; j = j+1) begin
                breg_shifted[j] <= 32'b0;
            end
            areg <= 16'b0;
            running <= 1'b0;
        end
        else if (start && !running) begin
            areg <= ain;
            // Pre-compute all possible shifted versions
            for (integer j = 0; j < 16; j = j+1) begin
                breg_shifted[j] <= bin << j;
            end
            running <= 1'b1;
        end
        else if (cycle == 15) begin
            running <= 1'b0;
        end
    end

    // Shift-and-add processing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 32'b0;
            cycle <= 4'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end
        else if (running) begin
            if (areg[cycle]) begin
                acc <= acc + breg_shifted[cycle];
            end
            
            if (cycle == 15) begin
                done <= 1'b1;
                yout <= acc + (areg[15] ? breg_shifted[15] : 32'b0);
                cycle <= 4'b0;
            end
            else begin
                cycle <= cycle + 1;
                done <= 1'b0;
            end
        end
        else begin
            done <= 1'b0;
            if (!start) begin
                acc <= 32'b0;
                yout <= 32'b0;
            end
        end
    end

endmodule