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

    // Next state combinational logic
    always @(*) begin
        if (!train_valid) begin
            // Hold current state if not training
            next_state = state;
        end else begin
            case (state)
                S0: next_state = train_taken ? S1 : S0; // increment if taken, saturate at 0 if not
                S1: next_state = train_taken ? S2 : S0; // increment or decrement
                S2: next_state = train_taken ? S3 : S1; 
                S3: next_state = train_taken ? S3 : S2; // saturate at max or decrement
                default: next_state = S1; // default safe state
            endcase
        end
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S1;
        end else begin
            state <= next_state;
        end
    end

endmodule