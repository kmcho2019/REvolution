module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Parameters for fractional division 3.5 = 7/2
    localparam DIV_MOD = 7;  // Modulus of accumulator
    localparam PHASE_INC = 2; // Increment per clk cycle

    reg [2:0] phase_acc;  // 3 bits sufficient for modulo 7 (0..6)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_acc <= 3'd0;
            clk_div <= 1'b0;
        end else begin
            // Add phase increment with modulo DIV_MOD arithmetic
            // Compute next phase
            // Use integer math: next_phase = (phase_acc + PHASE_INC) % DIV_MOD
            // Overflow occurs if sum >= DIV_MOD
            if (phase_acc + PHASE_INC >= DIV_MOD) begin
                // Wrap occurs: toggle clk_div
                phase_acc <= phase_acc + PHASE_INC - DIV_MOD;
                clk_div <= ~clk_div;
            end else begin
                phase_acc <= phase_acc + PHASE_INC;
                // No toggle on clk_div this cycle
            end
        end
    end

endmodule