module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [1:0] prev_state;

    always @(posedge clk) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} <= 4'b1111;
            prev_state <= 2'b11;
        end else begin
            // Update previous state
            prev_state <= s[2:1];

            // Set nominal flow outputs
            case (s)
                3'b111: {fr2, fr1, fr0} = 3'b000;  // Above all
                3'b011: {fr2, fr1, fr0} = 3'b001;   // Between s2-s1
                3'b001: {fr2, fr1, fr0} = 3'b011;   // Between s1-s0
                3'b000: {fr2, fr1, fr0} = 3'b111;   // Below all
            endcase

            // Set supplemental flow output
            dfr <= (s[2:1] > prev_state) || (s == 3'b000);
        end
    end

endmodule