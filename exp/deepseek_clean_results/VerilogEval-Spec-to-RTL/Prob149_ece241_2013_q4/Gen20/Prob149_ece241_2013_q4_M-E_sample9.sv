module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;  // Store previous sensor values

    // Output logic based on current sensors
    always @(*) begin
        casez (s)
            3'b??1: begin fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b0; end  // Above s[2]
            3'b?11: begin fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b1; end   // Between s[2]-s[1]
            3'b1?1: begin fr2 = 1'b0; fr1 = 1'b1; fr0 = 1'b1; end   // Between s[1]-s[0] (s[0] only)
            3'b000: begin fr2 = 1'b1; fr1 = 1'b1; fr0 = 1'b1; end   // Below s[0]
            default: begin fr2 = 1'b1; fr1 = 1'b1; fr0 = 1'b1; end  // Default to max flow
        endcase
    end

    // Transition detection and storage
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
            dfr <= 1'b1;
        end else begin
            // dfr is 1 if any sensor that was 0 is now 1 (water rising)
            dfr <= (s[0] & ~prev_s[0]) | 
                   (s[1] & ~prev_s[1]) | 
                   (s[2] & ~prev_s[2]);
            prev_s <= s;
        end
    end

endmodule