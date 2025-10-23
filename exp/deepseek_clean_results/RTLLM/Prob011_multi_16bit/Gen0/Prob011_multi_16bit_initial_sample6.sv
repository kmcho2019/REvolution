module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output wire done
);

    reg [15:0] areg, breg;
    reg [31:0] yout_r;
    reg [4:0] i; // Need 5 bits to count to 17 (0-16)
    reg done_r;

    // Output assignments
    assign done = done_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 5'b0;
            done_r <= 1'b0;
        end
        else begin
            if (start) begin
                if (i == 0) begin
                    // Initialization cycle
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'b0;
                    i <= i + 1;
                    done_r <= 1'b0;
                end
                else if (i <= 16) begin
                    // Processing cycles
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                    i <= i + 1;
                    
                    // Set done flag when i reaches 16
                    if (i == 16) begin
                        done_r <= 1'b1;
                    end
                    else begin
                        done_r <= 1'b0;
                    end
                end
                else begin
                    // i = 17, reset counter but keep result
                    i <= 5'b0;
                    done_r <= 1'b0;
                end
            end
            else begin
                // Start not asserted, reset counter
                i <= 5'b0;
                done_r <= 1'b0;
            end
        end
    end

    // Output assignment
    always @(*) begin
        yout = yout_r;
    end

endmodule