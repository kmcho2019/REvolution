module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    // Define states explicitly (0 to 3)
    localparam S0 = 2'd0;
    localparam S1 = 2'd1;  // reset state: weakly not-taken
    localparam S2 = 2'd2;
    localparam S3 = 2'd3;

    reg [1:0] next_state;

    always @(*) begin
        if (!train_valid) begin
            // Hold current state when not training
            next_state = state;
        end else begin
            // train_valid == 1: update saturating counter
            case (state)
                S0: begin
                    // minimum state, only increment if taken
                    if (train_taken)
                        next_state = S1;
                    else
                        next_state = S0;
                end
                S1: begin
                    if (train_taken)
                        next_state = S2;
                    else
                        next_state = S0;
                end
                S2: begin
                    if (train_taken)
                        next_state = S3;
                    else
                        next_state = S1;
                end
                S3: begin
                    // maximum state, only decrement if not taken
                    if (train_taken)
                        next_state = S3;
                    else
                        next_state = S2;
                end
                default: next_state = S1; // safe fallback to reset state
            endcase
        end
    end

    // Register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S1;  // weakly not-taken reset state
        end else begin
            state <= next_state;
        end
    end

endmodule