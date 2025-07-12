module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // One-hot state encoding
    reg [3:0] state;
    reg [3:0] prev_state;
    
    // State definitions
    localparam BELOW_S0  = 4'b0001;
    localparam BTW_S1_S0 = 4'b0010;
    localparam BTW_S2_S1 = 4'b0100;
    localparam ABOVE_S2  = 4'b1000;

    // Next state logic (continuous assignment)
    wire [3:0] next_state;
    assign next_state = 
        (s == 3'b111) ? ABOVE_S2 :
        (s == 3'b011) ? BTW_S2_S1 :
        (s == 3'b001) ? BTW_S1_S0 :
        BELOW_S0;

    // State transition and previous state tracking
    always @(posedge clk) begin
        if (reset) begin
            state <= BELOW_S0;
            prev_state <= BELOW_S0;
        end else begin
            prev_state <= state;
            state <= next_state;
        end
    end

    // Output assignments (directly from spec table)
    assign fr0 = (state != ABOVE_S2);
    assign fr1 = (state == BTW_S1_S0) || (state == BELOW_S0);
    assign fr2 = (state == BELOW_S0);
    
    // Supplemental flow (rising water detected)
    assign dfr = (state > prev_state);

endmodule