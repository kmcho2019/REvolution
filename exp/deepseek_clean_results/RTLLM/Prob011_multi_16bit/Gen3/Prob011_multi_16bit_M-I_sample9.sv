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
    reg [31:0] acc;
    reg [3:0] i; // Reduced to 4 bits (0-15)
    reg running;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            acc <= 32'b0;
            i <= 4'b0;
            done <= 1'b0;
            running <= 1'b0;
            for (integer j = 0; j < 16; j = j+1)
                shifted_b[j] <= 32'b0;
        end
        else begin
            if (start && !running) begin
                // Initialize on start
                areg <= ain;
                acc <= 32'b0;
                i <= 4'b0;
                done <= 1'b0;
                running <= 1'b1;
                
                // Pre-calculate all shifted versions
                shifted_b[0] <= {16'b0, bin};
                for (integer j = 1; j < 16; j = j+1)
                    shifted_b[j] <= shifted_b[j-1] << 1;
            end
            else if (running) begin
                // Processing cycles
                if (areg[i]) begin
                    acc <= acc + shifted_b[i];
                end
                
                if (i == 4'd15) begin
                    // Final cycle
                    yout <= acc + (areg[15] ? shifted_b[15] : 32'b0);
                    done <= 1'b1;
                    running <= 1'b0;
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