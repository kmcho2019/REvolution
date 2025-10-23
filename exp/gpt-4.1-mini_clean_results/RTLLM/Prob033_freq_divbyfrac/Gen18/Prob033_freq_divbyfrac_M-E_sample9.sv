module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Parameters
    // Division ratio = 3.5 = 7 / 2
    // Using phase accumulator with modulus 7 and increment 2
    localparam integer MODULO = 7;
    localparam integer INCREMENT = 2;

    // 3 bits needed to hold 0..6 for modulus 7
    reg [3:0] phase_acc; // 4 bits to accommodate overflow

    // To detect crossing of half modulo: 7/2=3.5
    // We'll toggle output when phase_acc crosses or equals 3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_acc <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            // Add increment mod 7 (0..6)
            if (phase_acc + INCREMENT >= MODULO)
                phase_acc <= phase_acc + INCREMENT - MODULO;
            else
                phase_acc <= phase_acc + INCREMENT;

            // Toggle clk_div whenever accumulator crosses half modulo (3 or more)
            // We check if accumulator is less than half before add, and >= half after add
            // or vice versa, to know edge crossing

            // Previous phase accumulator stored to compare crossing edge
            // But since only current phase_acc is stored, we'll infer toggle by toggling on phase_acc < INCREMENT condition

            // Alternate method: toggle clk_div whenever phase_acc < INCREMENT (2)
            // This happens once every full cycle because phase_acc wraps from (>=5) to 0..1.

            // Because increment = 2, clk_div toggles every time phase_acc wraps around.

            // So toggle clk_div when phase_acc < INCREMENT (2) after increment (means phase_acc wrapped around)

            if (phase_acc < INCREMENT)
                clk_div <= ~clk_div;
        end
    end

endmodule