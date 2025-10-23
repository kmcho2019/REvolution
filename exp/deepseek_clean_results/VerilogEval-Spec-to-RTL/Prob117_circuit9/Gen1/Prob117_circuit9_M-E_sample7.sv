module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Define states
localparam S4 = 3'd4;
localparam S5 = 3'd5;
localparam S6 = 3'd6;
localparam S0 = 3'd0;
localparam S1 = 3'd1;

// State transition logic
always @(posedge clk) begin
    case (q)
        S4: q <= a ? S4 : S5;
        S5: q <= a ? S5 : S6;
        S6: q <= a ? S6 : S0;
        S0: q <= a ? S0 : S1;
        S1: q <= a ? S1 : S4;  // After 1, wrap back to 4 as per waveform
        default: q <= S4;       // Initialize to 4
    endcase
end

endmodule