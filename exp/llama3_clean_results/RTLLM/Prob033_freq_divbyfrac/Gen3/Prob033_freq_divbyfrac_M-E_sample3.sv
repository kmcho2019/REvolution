module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg [1:0] phase;  // Clock phase signal
reg clk_phase_0;  // Clock phase 0
reg clk_phase_1;  // Clock phase 1
reg clk_phase_2;  // Clock phase 2
reg clk_phase_3;  // Clock phase 3
reg clk_phase_4;  // Clock phase 4
reg clk_phase_5;  // Clock phase 5
reg clk_phase_6;  // Clock phase 6

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        phase <= 2'b00;  // Reset phase
    end else begin
        // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;  // Reset counter
        end else begin
            cnt <= cnt + 1'b1;
        end

        // Update phase
        case (cnt)
            3'b000: phase <= 2'b00;
            3'b001: phase <= 2'b01;
            3'b010: phase <= 2'b10;
            3'b011: phase <= 2'b11;
            3'b100: phase <= 2'b00;
            3'b101: phase <= 2'b01;
            3'b110: phase <= 2'b10;
            3'b111: phase <= 2'b11;
        endcase
    end
end

// Clock phase generation
always @(posedge clk) begin
    // Clock phase 0
    if (phase == 2'b00) begin
        clk_phase_0 <= 1'b1;
    end else begin
        clk_phase_0 <= 1'b0;
    end

    // Clock phase 1
    if (phase == 2'b01) begin
        clk_phase_1 <= 1'b1;
    end else begin
        clk_phase_1 <= 1'b0;
    end

    // Clock phase 2
    if (phase == 2'b10) begin
        clk_phase_2 <= 1'b1;
    end else begin
        clk_phase_2 <= 1'b0;
    end

    // Clock phase 3
    if (phase == 2'b11) begin
        clk_phase_3 <= 1'b1;
    end else begin
        clk_phase_3 <= 1'b0;
    end

    // Clock phase 4
    if (phase == 2'b00) begin
        clk_phase_4 <= 1'b1;
    end else begin
        clk_phase_4 <= 1'b0;
    end

    // Clock phase 5
    if (phase == 2'b01) begin
        clk_phase_5 <= 1'b1;
    end else begin
        clk_phase_5 <= 1'b0;
    end

    // Clock phase 6
    if (phase == 2'b10) begin
        clk_phase_6 <= 1'b1;
    end else begin
        clk_phase_6 <= 1'b0;
    end
end

// Multiplexing logic
always @(posedge clk) begin
    case (cnt)
        3'b000: clk_div <= clk_phase_0;
        3'b001: clk_div <= clk_phase_1;
        3'b010: clk_div <= clk_phase_2;
        3'b011: clk_div <= clk_phase_3;
        3'b100: clk_div <= clk_phase_4;
        3'b101: clk_div <= clk_phase_5;
        3'b110: clk_div <= clk_phase_6;
        3'b111: clk_div <= 1'b0;
    endcase
end

endmodule