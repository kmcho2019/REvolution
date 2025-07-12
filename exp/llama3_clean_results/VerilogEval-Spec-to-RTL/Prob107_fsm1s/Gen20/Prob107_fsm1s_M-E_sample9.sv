module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states using one-hot encoding
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

reg state; // State variable

// ROM (LUT) for state machine
reg [1:0] rom_out; // Next state and output
always @(*) begin
    case({state, in})
        {STATE_B, 1'b0}: rom_out = {STATE_A, 1'b0}; // B, in=0 -> A, out=0
        {STATE_B, 1'b1}: rom_out = {STATE_B, 1'b1}; // B, in=1 -> B, out=1
        {STATE_A, 1'b0}: rom_out = {STATE_B, 1'b1}; // A, in=0 -> B, out=1
        {STATE_A, 1'b1}: rom_out = {STATE_A, 1'b0}; // A, in=1 -> A, out=0
        default: rom_out = {STATE_B, 1'b1}; // Default to B, out=1
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Reset to state B
    end else begin
        state <= rom_out[1]; // Update state from ROM output
    end
    out <= rom_out[0]; // Update output from ROM output
end

endmodule