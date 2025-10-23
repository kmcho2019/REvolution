module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] areg;          // Multiplicand register
    reg [15:0] breg;          // Multiplier register
    reg [31:0] yout_r;        // Product register
    reg [3:0] i;              // Reduced to 4-bit counter (0-15)
    reg done_r;               // Internal done flag
    reg active;               // Active operation flag
    reg [31:0] shifted_mult;  // Pipelined shifted multiplier
    wire [31:0] next_shifted; // Barrel shifter output
    wire mult_zero;           // Early termination flag

    // Early termination detection
    assign mult_zero = (bin == 16'b0);

    // Barrel shifter implementation
    assign next_shifted = (i == 0) ? {16'b0, bin} : 
                         (breg << i);

    // Clock gating logic
    wire clk_en = start | active | !rst_n;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 4'b0;
            done_r <= 1'b0;
            active <= 1'b0;
            shifted_mult <= 32'b0;
        end
        else if (clk_en) begin
            if (start && !active) begin
                // Initialize operation
                areg <= ain;
                breg <= bin;
                yout_r <= mult_zero ? 32'b0 : 32'b0;
                i <= 4'b0;
                done_r <= mult_zero;
                active <= !mult_zero;
                shifted_mult <= next_shifted;
            end
            else if (active) begin
                if (i < 15) begin
                    // Shift-and-add operation
                    if (areg[i]) begin
                        yout_r <= yout_r + shifted_mult;
                    end
                    i <= i + 1;
                    shifted_mult <= next_shifted;
                end
                else begin
                    // Final cycle
                    if (areg[i]) begin
                        yout_r <= yout_r + shifted_mult;
                    end
                    done_r <= 1'b1;
                    active <= 1'b0;
                end
            end
            else begin
                // Maintain done signal for one cycle
                done_r <= 1'b0;
            end
        end
    end

    // Output assignments
    always @(*) begin
        yout = yout_r;
        done = done_r;
    end

endmodule