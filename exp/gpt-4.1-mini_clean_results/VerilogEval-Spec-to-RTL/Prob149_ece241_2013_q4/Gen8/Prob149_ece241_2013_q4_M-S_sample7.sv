module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Water level encoding
    localparam BELOW_S0      = 2'd0;
    localparam BETWEEN_S1_S0 = 2'd1;
    localparam BETWEEN_S2_S1 = 2'd2;
    localparam ABOVE_S2      = 2'd3;

    reg [1:0] curr_level, prev_level;

    // Decode water level from sensors; treat unspecified patterns as BELOW_S0
    wire [1:0] decoded_level = 
        (s == 3'b111) ? ABOVE_S2 :
        (s == 3'b011) ? BETWEEN_S2_S1 :
        (s == 3'b001) ? BETWEEN_S1_S0 :
        (s == 3'b000) ? BELOW_S0 :
        BELOW_S0;

    // Update levels and dfr on clock edge synchronously with reset
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW_S0;
            prev_level <= BELOW_S0;
            dfr <= 1'b1; // all outputs asserted on reset, including dfr
        end else begin
            prev_level <= curr_level;
            curr_level <= decoded_level;
            // dfr asserted if water level increased
            dfr <= (decoded_level > curr_level) ? 1'b1 : 1'b0;
        end
    end

    // Nominal flow outputs combinationally from current level
    assign fr2 = (curr_level == BELOW_S0);
    assign fr1 = (curr_level == BELOW_S0) || (curr_level == BETWEEN_S1_S0);
    assign fr0 = (curr_level != ABOVE_S2);

endmodule