module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State encoding
localparam S0 = 2'b00;  // Strongly not-taken
localparam S1 = 2'b01;  // Weakly not-taken (reset state)
localparam S2 = 2'b10;  // Weakly taken
localparam S3 = 2'b11;  // Strongly taken

wire gated_clk;
assign gated_clk = clk & (train_valid | areset);

always @(posedge gated_clk or posedge areset) begin
    if (areset) begin
        state <= S1;
    end else if (train_valid) begin
        // Arithmetic-based state transition with saturation
        if (train_taken) begin
            state <= (state == S3) ? S3 : state + 1'b1;
        end else begin
            state <= (state == S0) ? S0 : state - 1'b1;
        end
    end
    // Else: clock is gated, state remains unchanged
end

endmodule