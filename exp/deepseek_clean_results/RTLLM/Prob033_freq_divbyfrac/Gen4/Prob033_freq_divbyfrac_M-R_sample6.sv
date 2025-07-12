module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// State counter (0-6 for 3.5x division)
reg [2:0] state;

// Next state logic
wire [2:0] next_state = (state == 3'd6) ? 3'd0 : state + 1;

// State transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 3'd0;
    end else begin
        state <= next_state;
    end
end

// Phase generation combinational logic
wire phase_a = (state < 3'd2) || (state == 3'd4);
wire phase_b = (state >= 3'd4);

// Output generation (registered to prevent glitches)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // OR of both phases creates the fractional division
        clk_div <= phase_a | phase_b;
    end
end

endmodule