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
    reg [4:0] i; // Counter (0-16)
    reg done_r;

    assign done = done_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 5'b0;
            done_r <= 1'b0;
        end else begin
            if (start) begin
                if (i == 0) begin
                    // Initial load of operands
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'b0;
                    done_r <= 1'b0;
                    i <= i + 1;
                end else if (i <= 16) begin
                    // Shift-and-add operation
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                    
                    // Update counter and done flag
                    if (i == 16) begin
                        done_r <= 1'b1;
                        i <= i + 1;
                    end else begin
                        i <= i + 1;
                    end
                end
            end else begin
                // Not started - reset counter
                i <= 5'b0;
                done_r <= 1'b0;
            end
        end
    end

    // Output assignment
    always @(posedge clk) begin
        yout <= yout_r;
    end

endmodule