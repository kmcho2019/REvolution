module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// State encoding
localparam S0 = 3'd0; // no bits matched
localparam S1 = 3'd1; // matched '1'
localparam S2 = 3'd2; // matched '10'
localparam S3 = 3'd3; // matched '100'
localparam S4 = 3'd4; // matched '1001'

reg [2:0] state, next_state;

// Next state logic: simplified and flattened for faster combinational path
always @(*) begin
    case (state)
        S0: next_state = (IN == 1'b1) ? S1 : S0;
        S1: next_state = (IN == 1'b0) ? S2 : S1;
        S2: next_state = (IN == 1'b0) ? S3 : S1;
        S3: next_state = (IN == 1'b1) ? S4 : S0;
        S4: next_state = (IN == 1'b1) ? S1 : S2;
        default: next_state = S0;
    endcase
end

// State update on clock edge or reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        // Mealy output: MATCH is asserted when current state is S4 and input is 1
        // This means the sequence "10011" just completed at this clock cycle
        MATCH <= (state == S4) && (IN == 1'b1);
    end
end

endmodule