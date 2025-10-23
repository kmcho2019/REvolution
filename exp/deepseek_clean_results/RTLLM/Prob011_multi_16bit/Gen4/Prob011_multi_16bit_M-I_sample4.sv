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
    reg [31:0] shifted_b [0:15]; // Pre-shifted versions of bin
    reg [31:0] yout_r;
    reg [3:0] i; // 4-bit counter (0-15)
    reg processing;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            yout_r <= 32'b0;
            i <= 4'b0;
            done <= 1'b0;
            processing <= 1'b0;
            for (integer j = 0; j < 16; j = j+1)
                shifted_b[j] <= 32'b0;
        end
        else begin
            if (start && !processing) begin
                // Initialization cycle
                areg <= ain;
                yout_r <= 32'b0;
                i <= 4'b0;
                done <= 1'b0;
                processing <= 1'b1;
                
                // Pre-calculate all shifted versions
                shifted_b[0] <= {16'b0, bin};
                for (integer j = 1; j < 16; j = j+1)
                    shifted_b[j] <= shifted_b[j-1] << 1;
            end
            else if (processing) begin
                // Processing cycles
                if (areg[i]) begin
                    yout_r <= yout_r + shifted_b[i];
                end
                
                if (i == 4'b1111) begin
                    // Last cycle
                    done <= 1'b1;
                    processing <= 1'b0;
                    yout <= yout_r + (areg[15] ? shifted_b[15] : 32'b0);
                end
                else begin
                    i <= i + 1;
                end
            end
            else begin
                done <= 1'b0;
            end
        end
    end

endmodule