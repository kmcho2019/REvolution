module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;

// Define the states
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

always @(posedge clk) begin
    if (reset) begin
        state <= S1; // Reset state to S1
    end else if (state == S10) begin
        state <= S1; // Wrap around to S1
    end else begin
        state <= state + 1; // Transition to the next state
    end
end

// Assign the output q based on the current state
assign q = state;

endmodule