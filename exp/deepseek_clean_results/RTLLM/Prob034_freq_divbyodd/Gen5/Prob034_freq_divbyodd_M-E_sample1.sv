module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_DIV = (NUM_DIV - 1) / 2;

// Positive edge domain
reg [31:0] cnt_pos;
reg pulse_pos;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 0;
        pulse_pos <= 0;
    end
    else begin
        if (cnt_pos == HALF_DIV) begin
            pulse_pos <= ~pulse_pos;
            cnt_pos <= 0;
        end
        else begin
            cnt_pos <= cnt_pos + 1;
        end
    end
end

// Negative edge domain
reg [31:0] cnt_neg;
reg pulse_neg;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 0;
        pulse_neg <= 0;
    end
    else begin
        if (cnt_neg == HALF_DIV) begin
            pulse_neg <= ~pulse_neg;
            cnt_neg <= 0;
        end
        else begin
            cnt_neg <= cnt_neg + 1;
        end
    end
end

// Phase alignment detector
reg phase_ok;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_ok <= 0;
    end
    else begin
        phase_ok <= (pulse_pos ^ pulse_neg) ? 1 : phase_ok;
    end
end

// Output generation
assign clk_div = phase_ok ? (pulse_pos ^ pulse_neg) : 0;

endmodule