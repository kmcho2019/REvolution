module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // LUT implementation for Y1 and Y3
    reg [1:0] transition_lut [6:0];
    
    initial begin
        // Format: {Y3, Y1}
        transition_lut[6'b000001] = {1'b0, w};      // State A
        transition_lut[6'b000010] = {~w, w};        // State B
        transition_lut[6'b000100] = {~w, 1'b0};     // State C
        transition_lut[6'b001000] = {~w, 1'b0};     // State D
        transition_lut[6'b010000] = {~w, 1'b1};     // State E
        transition_lut[6'b100000] = {~w, 1'b0};     // State F
        transition_lut[6'b000000] = {1'b0, 1'b0};   // Invalid state
    end

    wire [1:0] transition_out;
    assign transition_out = transition_lut[y];
    
    assign Y1 = transition_out[0];
    assign Y3 = transition_out[1];

endmodule