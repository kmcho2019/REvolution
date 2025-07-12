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
    wire [31:0] shifted_b [0:15];
    wire [15:0] shift_sel;
    reg accum_en;

    // Pre-calculate all possible shifted versions of breg
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : shift_gen
            assign shifted_b[j] = {16'b0, breg} << j;
        end
    endgenerate

    // Shift selection based on counter
    assign shift_sel = (i < 16) ? (16'b1 << i) : 16'b0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            yout <= 32'b0;
            i <= 4'b0;
            done <= 1'b0;
            accum_en <= 1'b0;
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
                else if (i < 16) begin
                    // Processing cycles
                    accum_en <= areg[i-1]; // Clock gating control
                    if (accum_en) begin
                        yout_r <= yout_r + shifted_b[i-1];
                    end
                    i <= i + 1;
                    
                    // Set done flag when i reaches 15 (last cycle)
                    done <= (i == 15);
                end
                else begin
                    // Final cycle (i = 15), capture output
                    yout <= yout_r;
                    i <= 4'b0;
                    done <= 1'b0;
                end
            end
            else begin
                // Start not asserted, reset everything
                areg <= 16'b0;
                breg <= 16'b0;
                yout_r <= 32'b0;
                i <= 4'b0;
                done <= 1'b0;
                accum_en <= 1'b0;
            end
        end
    end

endmodule