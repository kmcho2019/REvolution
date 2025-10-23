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

    wire [1:0] next_state;

    // Combinational logic for next state using assign
    assign next_state = (!train_valid) ? state :
                        (state == S0) ? (train_taken ? S1 : S0) :
                        (state == S1) ? (train_taken ? S2 : S0) :
                        (state == S2) ? (train_taken ? S3 : S1) :
                        (state == S3) ? (train_taken ? S3 : S2) :
                        S1; // default safe state

    // Sequential logic with asynchronous positive edge reset and enable on train_valid
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S1;
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold current state (no toggling)
    end

endmodule