module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] areg;       // Multiplicand register
    reg [15:0] breg;       // Multiplier register
    reg [31:0] yout_r;      // Product register
    reg [31:0] shifted_b;   // Pipelined shifted multiplier
    reg [3:0] i;           // Reduced counter width (4 bits)
    reg done_r;            // Internal done flag
    reg active;            // Clock gating control
    wire clk_gated;        // Gated clock

    // Clock gating logic
    assign clk_gated = clk & active;

    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            shifted_b <= 32'b0;
            i <= 4'b0;
            done_r <= 1'b0;
        end
        else begin
            if (i == 0) begin
                // Load operands at start
                areg <= ain;
                breg <= bin;
                yout_r <= 32'b0;
                shifted_b <= {16'b0, bin};
                i <= i + 1;
                done_r <= 1'b0;
            end
            else if (i < 16) begin
                // Shift-and-add operation with pipelined shift
                if (areg[i-1]) begin
                    yout_r <= yout_r + shifted_b;
                end
                shifted_b <= shifted_b << 1; // Barrel shift
                i <= i + 1;
                done_r <= (i == 15) ? 1'b1 : 1'b0;
            end
            else begin
                // Multiplication complete
                done_r <= 1'b0;
            end
        end
    end

    // Control logic for clock gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            active <= 1'b0;
        end
        else begin
            if (start && i < 16) begin
                active <= 1'b1;
            end
            else begin
                active <= 1'b0;
            end
        end
    end

    // Output assignments with operand isolation
    always @(*) begin
        yout = (done_r) ? yout_r : 32'b0;
        done = done_r;
    end

endmodule