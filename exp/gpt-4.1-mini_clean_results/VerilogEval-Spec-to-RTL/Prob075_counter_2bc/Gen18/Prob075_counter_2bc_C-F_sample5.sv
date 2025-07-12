module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // State encoding for clarity
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;  // weakly not-taken (reset state)
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;

    reg [1:0] next_state;

    // Combinational next state logic, only updated when train_valid=1
    always @(*) begin
        if (!train_valid) begin
            next_state = state; // Hold current state when not training
        end else begin
            case (state)
                S0: next_state = train_taken ? S1 : S0; 
                S1: next_state = train_taken ? S2 : S0;
                S2: next_state = train_taken ? S3 : S1;
                S3: next_state = train_taken ? S3 : S2;
                default: next_state = S1; // Safe default to reset state
            endcase
        end
    end

    // Sequential logic with asynchronous positive edge reset and enable on train_valid
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S1;
        end else if (train_valid) begin
            state <= next_state;
        end
        // else keep the current state (no toggling)
    end

endmodule