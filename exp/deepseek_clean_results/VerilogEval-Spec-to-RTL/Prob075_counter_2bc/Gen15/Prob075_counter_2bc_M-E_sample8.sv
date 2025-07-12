module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// One-hot like state encoding for potential power benefits
localparam [1:0] S0 = 2'b00;
localparam [1:0] S1 = 2'b01;
localparam [1:0] S2 = 2'b10;
localparam [1:0] S3 = 2'b11;

reg [1:0] next_state;

// Next state logic using case statements
always @(*) begin
    if (train_valid) begin
        case (state)
            S0: next_state = train_taken ? S1 : S0;
            S1: next_state = train_taken ? S2 : S0;
            S2: next_state = train_taken ? S3 : S1;
            S3: next_state = train_taken ? S3 : S2;
            default: next_state = S1;
        endcase
    end else begin
        next_state = state;  // Hold current state when not training
    end
end

// State register with async reset and enable
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= S1;  // Weakly not-taken state
    else if (train_valid)  // Only update when training
        state <= next_state;
    // else hold (implicit)
end

endmodule