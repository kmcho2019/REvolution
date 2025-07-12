module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] main_counter;
reg sub_counter;
reg [3:0] phase;

// Main counter (0-6) for 3.5x division
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        main_counter <= 3'b0;
    end else begin
        main_counter <= (main_counter == 3'd6) ? 3'b0 : main_counter + 1'b1;
    end
end

// Sub-counter for half-cycle timing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sub_counter <= 1'b0;
    end else begin
        sub_counter <= ~sub_counter;
    end
end

// Four-phase generation
always @(*) begin
    case ({main_counter, sub_counter})
        // 4-clock phase (wider pulses)
        4'b000_0: phase = 4'b0001;
        4'b000_1: phase = 4'b0011;
        4'b001_0: phase = 4'b0111;
        4'b001_1: phase = 4'b1111;
        4'b010_0: phase = 4'b1110;
        4'b010_1: phase = 4'b1100;
        
        // 3-clock phase (narrower pulses)
        4'b011_0: phase = 4'b1000;
        4'b011_1: phase = 4'b1100;
        4'b100_0: phase = 4'b1110;
        4'b100_1: phase = 4'b1111;
        4'b101_0: phase = 4'b0111;
        4'b101_1: phase = 4'b0011;
        4'b110_0: phase = 4'b0001;
        4'b110_1: phase = 4'b0000;
        
        default: phase = 4'b0000;
    endcase
end

// Final output combination (XOR of phases)
assign clk_div = ^phase;

endmodule