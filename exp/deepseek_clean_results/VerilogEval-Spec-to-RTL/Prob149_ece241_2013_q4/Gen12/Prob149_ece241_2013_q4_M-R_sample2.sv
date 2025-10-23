module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] prev_s;
    wire water_rising;
    wire [2:0] nominal_flows;

    // Track previous sensor state
    always @(posedge clk) begin
        if (reset)
            prev_s <= 3'b000;
        else
            prev_s <= s;
    end

    // Rising water detection: any sensor newly asserted
    assign water_rising = ((s[0] & ~prev_s[0]) | 
                          (s[1] & ~prev_s[1]) | 
                          (s[2] & ~prev_s[2]));

    // Nominal flow outputs (combinational)
    assign nominal_flows = (s == 3'b111) ? 3'b000 :  // Above all
                          (s == 3'b011) ? 3'b001 :   // Between s2-s1
                          (s == 3'b001) ? 3'b011 :   // Between s1-s0
                          3'b111;                   // Below all

    assign {fr2, fr1, fr0} = reset ? 3'b111 : nominal_flows;
    assign dfr = reset ? 1'b1 : (s == 3'b000) | water_rising;

endmodule