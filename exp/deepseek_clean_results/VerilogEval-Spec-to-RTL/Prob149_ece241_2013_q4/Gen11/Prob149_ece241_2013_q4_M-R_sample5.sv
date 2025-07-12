module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Water level states
    localparam BELOW_S0 = 2'b00;
    localparam S0_S1    = 2'b01;
    localparam S1_S2    = 2'b10;
    localparam ABOVE_S2 = 2'b11;

    reg [1:0] current_level;
    reg [1:0] prev_level;

    // Combinational logic for current level
    wire [1:0] next_level = 
        (s == 3'b000) ? BELOW_S0 :
        (s == 3'b001) ? S0_S1 :
        (s == 3'b011) ? S1_S2 :
        ABOVE_S2;  // All other cases treated as above s[2]

    // Combinational outputs based on current level
    assign fr0 = (current_level != ABOVE_S2);
    assign fr1 = (current_level == BELOW_S0) || (current_level == S0_S1);
    assign fr2 = (current_level == BELOW_S0);

    // Sequential logic for state and dfr
    always @(posedge clk) begin
        if (reset) begin
            current_level <= BELOW_S0;
            prev_level <= BELOW_S0;
        end else begin
            prev_level <= current_level;
            current_level <= next_level;
        end
    end

    // dfr is 1 when current level is higher than previous
    assign dfr = (current_level > prev_level);

endmodule