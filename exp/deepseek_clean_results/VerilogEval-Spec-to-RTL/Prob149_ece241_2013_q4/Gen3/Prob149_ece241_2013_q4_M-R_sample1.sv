module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Current zone detection (combinational)
    wire [1:0] current_zone = 
        (s == 3'b111) ? 2'b00 :       // Above s[2]
        (s == 3'b011) ? 2'b01 :       // Between s[2]-s[1]
        (s == 3'b001) ? 2'b10 :       // Between s[1]-s[0]
        2'b11;                        // Below s[0]

    // Previous zone storage
    reg [1:0] prev_zone;
    always @(posedge clk) begin
        if (reset) begin
            prev_zone <= 2'b11;  // Start as if coming from below
        end else begin
            prev_zone <= current_zone;
        end
    end

    // Output generation (combinational)
    always @(*) begin
        if (reset) begin
            // Reset forces all outputs high
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end else begin
            // Nominal flow rates based on current zone
            fr0 = (current_zone >= 2'b01);
            fr1 = (current_zone >= 2'b10);
            fr2 = (current_zone == 2'b11);
            
            // Supplemental flow if coming from lower zone
            dfr = (current_zone < prev_zone);
        end
    end

endmodule