module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;
    reg       data_en_d;        // delayed data_en for edge detection
    reg       en_pulse_a;       // single cycle pulse on rising edge of data_en

    // clk_b domain registers for pulse synchronizer
    reg en_pulse_b_ff1, en_pulse_b_ff2;
    reg en_pulse_b_ff2_d;       // delayed version for pulse detection

    // clk_a domain: detect rising edge of data_en and latch data_in on that edge
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg   <= 4'd0;
            data_en_d  <= 1'b0;
            en_pulse_a <= 1'b0;
        end else begin
            data_en_d <= data_en;
            en_pulse_a <= data_en & (~data_en_d); // pulse generated for rising edge only
            if (en_pulse_a)
                data_reg <= data_in;
        end
    end

    // clk_b domain: two-stage synchronizer for the pulse
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_pulse_b_ff1 <= 1'b0;
            en_pulse_b_ff2 <= 1'b0;
            en_pulse_b_ff2_d <= 1'b0;
            dataout        <= 4'd0;
        end else begin
            en_pulse_b_ff1 <= en_pulse_a;
            en_pulse_b_ff2 <= en_pulse_b_ff1;

            // detect pulse rising edge in clk_b domain
            en_pulse_b_ff2_d <= en_pulse_b_ff2;

            if (en_pulse_b_ff2 & ~en_pulse_b_ff2_d) begin
                dataout <= data_reg;
            end
            // else retain previous dataout
        end
    end

endmodule