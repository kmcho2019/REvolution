module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // Correct 4-bit one-hot state encoding
    localparam S0 = 4'b0001;
    localparam S1 = 4'b0010;
    localparam S2 = 4'b0100;
    localparam S3 = 4'b1000;
    
    reg [3:0] state;

    assign shift_ena = |state;  // OR of all state bits (high for any active state)

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;  // Start sequence on reset
        end else begin
            case (state)
                S0: state <= S1;
                S1: state <= S2;
                S2: state <= S3;
                S3: state <= 4'b0000;  // Transition to inactive (all zeros)
                default: state <= 4'b0000;  // Default to inactive
            endcase
        end
    end

endmodule