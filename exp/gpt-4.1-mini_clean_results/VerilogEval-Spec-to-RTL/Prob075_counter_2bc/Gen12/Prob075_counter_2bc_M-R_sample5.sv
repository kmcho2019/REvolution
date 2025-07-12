module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // State encoding
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;  // weakly not-taken (reset state)
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;

    // Compute next state using continuous assignment and conditional operators
    wire [1:0] next_state;
    assign next_state = (!train_valid) ? state :
                        (state == S0) ? (train_taken ? S1 : S0) :
                        (state == S1) ? (train_taken ? S2 : S0) :
                        (state == S2) ? (train_taken ? S3 : S1) :
                        (state == S3) ? (train_taken ? S3 : S2) :
                        S1; // default safe state

    // Sequential logic with async positive edge reset and enable on train_valid
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S1;
        else if (train_valid)
            state <= next_state;
        // else hold state
    end

endmodule