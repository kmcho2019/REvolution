module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

// Define states for the decade counter
localparam S1 = 4'd1;
localparam S2 = 4'd2;
localparam S3 = 4'd3;
localparam S4 = 4'd4;
localparam S5 = 4'd5;
localparam S6 = 4'd6;
localparam S7 = 4'd7;
localparam S8 = 4'd8;
localparam S9 = 4'd9;
localparam S10 = 4'd10;

reg [3:0] state;
reg [3:0] next_state;

// Combinational logic to determine next state
always @(*) begin
    case (state)
        S1: next_state = S2;
        S2: next_state = S3;
        S3: next_state = S4;
        S4: next_state = S5;
        S5: next_state = S6;
        S6: next_state = S7;
        S7: next_state = S8;
        S8: next_state = S9;
        S9: next_state = S10;
        S10: next_state = reset ? S1 : S1; // Reset or wrap around
        default: next_state = reset ? S1 : S1;
    endcase
end

// Sequential logic to update state
always @(posedge clk) begin
    if (reset) begin
        state <= S1;
    end else begin
        state <= next_state;
    end
end

// Directly assign state to output
assign q = state;

endmodule