module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State definitions
localparam S0 = 2'b00;  // Strongly not-taken
localparam S1 = 2'b01;  // Weakly not-taken
localparam S2 = 2'b10;  // Weakly taken
localparam S3 = 2'b11;  // Strongly taken

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S1;  // Reset to weakly not-taken
    end else if (train_valid) begin
        case (state)
            S0: state <= train_taken ? S1 : S0;
            S1: state <= train_taken ? S2 : S0;
            S2: state <= train_taken ? S3 : S1;
            S3: state <= train_taken ? S3 : S2;
        endcase
    end
end

endmodule