module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [6:0] state; // 7-bit state counter (128 possible states for 64-bit Johnson)
wire terminal_state;

// Terminal state detection
assign terminal_state = (Q == 64'h0) || (Q == {64{1'b1}});

// Parallel pattern generation
always @(*) begin
    case(state[6:0])
        7'd0: Q = 64'h0;
        7'd1: Q = 64'h8000000000000000;
        7'd2: Q = 64'hC000000000000000;
        7'd3: Q = 64'hE000000000000000;
        // ... (pattern continues with more 1s)
        7'd63: Q = 64'hFFFFFFFFFFFFFFFE;
        7'd64: Q = 64'hFFFFFFFFFFFFFFFF;
        7'd65: Q = 64'h7FFFFFFFFFFFFFFF;
        7'd66: Q = 64'h3FFFFFFFFFFFFFFF;
        // ... (pattern continues with more 0s)
        7'd127: Q = 64'h0000000000000001;
        default: Q = 64'h0;
    endcase
end

// State counter with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 7'd0;
    end else if (!terminal_state) begin // Clock gating
        state <= state + 1;
        if (state == 7'd127) state <= 7'd0;
    end
end

// Optional: Synthesis attributes for better optimization
// synthesis attribute async_reg of Q is "true";
// synthesis attribute rom_extract of Q is "yes";

endmodule