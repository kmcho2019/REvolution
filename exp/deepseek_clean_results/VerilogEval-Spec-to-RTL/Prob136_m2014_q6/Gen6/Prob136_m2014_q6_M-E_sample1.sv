module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State mapping to counter values
    parameter [3:0] A = 4'd0,
                    B = 4'd1,
                    C = 4'd2,
                    D = 4'd3,
                    E = 4'd4,
                    F = 4'd5;

    reg [3:0] state_counter;
    wire [3:0] rom_out;

    // ROM implementation (16x4) - index is {state_counter[3:0], w}
    // Format: {next_state[3:0], z}
    // Implemented as a case statement for synthesis
    always @(*) begin
        case ({state_counter, w})
            // State A transitions
            {A, 1'b0}: rom_out = {B, 1'b0};
            {A, 1'b1}: rom_out = {A, 1'b0};
            // State B transitions
            {B, 1'b0}: rom_out = {C, 1'b0};
            {B, 1'b1}: rom_out = {D, 1'b0};
            // State C transitions
            {C, 1'b0}: rom_out = {E, 1'b1};
            {C, 1'b1}: rom_out = {D, 1'b0};
            // State D transitions
            {D, 1'b0}: rom_out = {F, 1'b1};
            {D, 1'b1}: rom_out = {A, 1'b0};
            // State E transitions
            {E, 1'b0}: rom_out = {E, 1'b1};
            {E, 1'b1}: rom_out = {D, 1'b0};
            // State F transitions
            {F, 1'b0}: rom_out = {C, 1'b1};
            {F, 1'b1}: rom_out = {D, 1'b0};
            // Default case (should never occur)
            default: rom_out = {A, 1'b0};
        endcase
    end

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state_counter <= A;
            z <= 1'b0;
        end
        else begin
            state_counter <= rom_out[3:0]; // Next state
            z <= rom_out[4];              // Current output
        end
    end

endmodule