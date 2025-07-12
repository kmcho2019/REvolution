module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

always @(posedge clk) begin
    if (reset) begin
        // Reset state: all sensors deasserted, maximum flow rate
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        if (s[2]) begin
            // Water level above s[2]: zero flow rate
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s[1]) begin
            // Water level between s[2] and s[1]: nominal flow rate (fr0)
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            dfr <= 1'b0; // Unless the water level was previously lower
        end else if (s[0]) begin
            // Water level between s[1] and s[0]: nominal flow rate (fr0, fr1)
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b0; // Unless the water level was previously lower
        end else begin
            // Water level below s[0]: maximum flow rate
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end
    end
end

// Add additional logic to control dfr based on previous sensor changes
reg [2:0] prev_s;
always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b0;
    end else begin
        prev_s <= s;
    end
end

always @(*) begin
    if (s > prev_s) begin
        dfr = 1'b1;
    end else begin
        dfr = 1'b0;
    end
end

endmodule