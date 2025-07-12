module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for clock phase generator
reg [1:0] phase_clk;  // Phase-shifted clocks

// Signals for time-domain multiplexer
reg [2:0] seq_counter;  // Sequence counter for time-domain multiplexer
reg [2:0] seq_state;    // State register for time-domain multiplexer
reg tdm_clk;             // Output clock signal from time-domain multiplexer

// Signals for output clock generator
reg out_clk;  // Final output clock signal

// Clock phase generator implementation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        phase_clk <= 2'b00;
    end else begin
        // Generate phase-shifted clocks with 90-degree phase difference
        case (phase_clk)
            2'b00: phase_clk <= 2'b01;
            2'b01: phase_clk <= 2'b10;
            2'b10: phase_clk <= 2'b11;
            2'b11: phase_clk <= 2'b00;
            default: phase_clk <= 2'b00;
        endcase
    end
end

// Time-domain multiplexer implementation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        seq_counter <= 3'd0;
        seq_state <= 3'd0;
        tdm_clk <= 1'b0;
    end else begin
        // Assign phase-shifted clocks to time slots based on sequence
        case (seq_state)
            3'd0: begin
                tdm_clk <= phase_clk[0];
                seq_counter <= seq_counter + 1;
                if (seq_counter == 3'd4) begin
                    seq_state <= 3'd1;
                end
            end
            3'd1: begin
                tdm_clk <= phase_clk[1];
                seq_counter <= seq_counter + 1;
                if (seq_counter == 3'd7) begin
                    seq_state <= 3'd0;
                    seq_counter <= 3'd0;
                end
            end
            default: begin
                seq_state <= 3'd0;
            end
        endcase
    end
end

// Output clock generator implementation
always @(posedge tdm_clk or negedge rst_n) begin
    if (~rst_n) begin
        out_clk <= 1'b0;
    end else begin
        // Generate final output clock by logically OR-ing phase-shifted clocks
        out_clk <= tdm_clk;
    end
end

// Assign output clock signal to clk_div
assign clk_div = out_clk;

endmodule