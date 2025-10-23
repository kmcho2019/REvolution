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
    wire rising;

    // Detect if any sensor that was 0 is now 1 (water level rising)
    assign rising = (s[0] & ~prev_s[0]) | 
                   (s[1] & ~prev_s[1]) | 
                   (s[2] & ~prev_s[2]);

    always @(posedge clk) begin
        if (reset) begin
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
            
            // Below s[0] (no sensors)
            if (s == 3'b000) begin
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
            // Between s[1] and s[0]
            else if (s == 3'b001) begin
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b0;
            end
            // Between s[2] and s[1]
            else if (s == 3'b011) begin
                fr0 <= 1'b1;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            // Above s[2]
            else begin
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            
            dfr <= rising;
        end
    end

endmodule