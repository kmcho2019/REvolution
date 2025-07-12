module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Reduced state encoding (2 bits)
localparam S0 = 2'b00; // no match
localparam S1 = 2'b01; // matched '1'
localparam S2 = 2'b10; // matched "11"
localparam S3 = 2'b11; // matched "110"

// State register
reg [1:0] state, next_state;

// Synchronous state update and output latch
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (next_state == S3 && data) // Detect '1101' sequence at this transition
            start_shifting <= 1;
    end
end

// Next-state combinational logic
always @(*) begin
    case (state)
        S0: next_state = data ? S1 : S0;
        S1: next_state = data ? S2 : S0;
        S2: next_state = data ? S2 : S3;
        S3: next_state = data ? S1 : S0;
        default: next_state = S0;
    endcase
end

endmodule