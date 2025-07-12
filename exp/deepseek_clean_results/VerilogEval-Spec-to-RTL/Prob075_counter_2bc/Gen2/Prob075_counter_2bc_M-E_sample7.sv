module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    // State encoding
    localparam S0 = 2'b00;  // Strongly not-taken
    localparam S1 = 2'b01;  // Weakly not-taken (reset state)
    localparam S2 = 2'b10;  // Weakly taken
    localparam S3 = 2'b11;  // Strongly taken

    reg [1:0] current_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S1;  // Reset to weakly not-taken
        end else if (train_valid) begin
            case (current_state)
                S0: current_state <= train_taken ? S1 : S0;  // Can only increment from min
                S1: current_state <= train_taken ? S2 : S0;
                S2: current_state <= train_taken ? S3 : S1;
                S3: current_state <= train_taken ? S3 : S2;  // Can only decrement from max
                default: current_state <= S1;  // Should never happen
            endcase
        end
        // Else: state remains unchanged
    end

    assign state = current_state;

endmodule