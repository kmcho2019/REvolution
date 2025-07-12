module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s; // Previous sensor state

// Sequential logic to update previous sensor state
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update previous sensor state
        prev_s <= s;
    end
end

// Combinational logic to determine output signals (fr2, fr1, fr0) and dfr
always @(*) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
        dfr = 1'b1;
    end else begin
        // Determine output signals based on input sensor values
        if (s[2] == 1'b1) begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end else if (s[1] == 1'b1) begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = (prev_s[1] == 1'b0 && s[1] == 1'b1) || (prev_s[2] == 1'b0 && s[1] == 1'b1);
        end else if (s[0] == 1'b1) begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (prev_s[0] == 1'b0 && s[0] == 1'b1) || (prev_s[1] == 1'b0 && s[0] == 1'b1);
        end else begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (prev_s[0] == 1'b1 && s[0] == 1'b0) || (prev_s[1] == 1'b1 && s[1] == 1'b0) || (prev_s[2] == 1'b1 && s[2] == 1'b0);
        end
    end
end

endmodule