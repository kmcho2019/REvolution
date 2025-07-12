module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;

    // Output logic based on current sensors
    always @(*) begin
        case (s)
            3'b000: {fr2, fr1, fr0} = 3'b111; // Below s[0]
            3'b001: {fr2, fr1, fr0} = 3'b011; // Between s[1]-s[0]
            3'b011: {fr2, fr1, fr0} = 3'b001; // Between s[2]-s[1]
            3'b111: {fr2, fr1, fr0} = 3'b000; // Above s[2]
            default: {fr2, fr1, fr0} = 3'b111; // Default to max flow
        endcase
    end

    // Transition detection and register update
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
            dfr <= 1'b1;
        end else begin
            // dfr is 1 if water level is rising (current sensors > previous)
            dfr <= (s > prev_s);
            prev_s <= s;
        end
    end

endmodule