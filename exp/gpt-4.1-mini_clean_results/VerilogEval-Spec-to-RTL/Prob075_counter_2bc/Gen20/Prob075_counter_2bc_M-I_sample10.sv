module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    // Define state encodings for clarity
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;  // weakly not-taken (reset state)
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;

    reg [1:0] next_state;

    // Generate gated clock: latch enable signal to avoid glitches
    reg clk_en;
    always @(posedge clk or posedge areset) begin
        if (areset)
            clk_en <= 1'b0;
        else
            clk_en <= train_valid;
    end

    wire gated_clk = clk & clk_en;

    // Next state combinational logic
    always @(*) begin
        if (!train_valid) begin
            // Hold current state if not training
            next_state = state;
        end else begin
            case (state)
                S0: next_state = train_taken ? S1 : S0; 
                S1: next_state = train_taken ? S2 : S0; 
                S2: next_state = train_taken ? S3 : S1; 
                S3: next_state = train_taken ? S3 : S2; 
                default: next_state = S1; 
            endcase
        end
    end

    // Sequential logic with asynchronous positive edge reset and gated clock
    // Use gated_clk instead of clk to reduce unnecessary toggles
    always @(posedge gated_clk or posedge areset) begin
        if (areset) begin
            state <= S1;
        end else begin
            state <= next_state;
        end
    end

endmodule