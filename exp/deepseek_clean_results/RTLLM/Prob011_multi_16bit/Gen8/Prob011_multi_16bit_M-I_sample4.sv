module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] areg, breg;
    reg [31:0] yout_r;
    reg [3:0] i; // Reduced to 4 bits (0-15)
    wire [31:0] shifted_b [15:0];
    wire [31:0] selected_shift;

    // Pre-calculate all possible shifted versions
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : shift_gen
            assign shifted_b[j] = {16'b0, breg} << j;
        end
    endgenerate

    // Select appropriate shift based on current bit position
    assign selected_shift = (i > 0) ? shifted_b[i-1] : 32'b0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 4'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end
        else begin
            if (start) begin
                if (i == 0) begin
                    // Initialization cycle
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'b0;
                    i <= i + 1;
                    done <= 1'b0;
                end
                else if (i <= 15) begin
                    // Processing cycles
                    if (areg[i-1]) begin
                        yout_r <= yout_r + selected_shift;
                    end
                    i <= i + 1;
                    
                    // Set done flag when processing last bit
                    done <= (i == 15);
                end
                else begin
                    // Operation complete, hold result
                    done <= 1'b0;
                    yout <= yout_r;
                end
            end
            else begin
                // Start not asserted, reset everything
                areg <= 16'b0;
                breg <= 16'b0;
                yout_r <= 32'b0;
                i <= 4'b0;
                done <= 1'b0;
            end
        end
    end

endmodule