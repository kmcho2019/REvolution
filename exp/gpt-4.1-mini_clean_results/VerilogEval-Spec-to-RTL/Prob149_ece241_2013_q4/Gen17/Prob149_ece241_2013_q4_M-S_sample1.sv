module TopModule(
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output reg    dfr
);

    reg [1:0] prev_level, current_level;

    // Decode sensors to water level (0=below s[0], 1=s[0] only, 2=s[0]&s[1], 3=all sensors)
    wire [1:0] level = (s == 3'b111) ? 2'd3 :
                       (s == 3'b011) ? 2'd2 :
                       (s == 3'b001) ? 2'd1 : 2'd0;

    always @(posedge clk) begin
        if (reset) begin
            current_level <= 2'd0;
            prev_level <= 2'd0;
            dfr <= 1'b1;
        end else begin
            prev_level <= current_level;
            current_level <= level;
            dfr <= (level > prev_level);
        end
    end

    assign fr0 = (current_level != 2'd3);
    assign fr1 = (current_level <= 2'd1);
    assign fr2 = (current_level == 2'd0);

endmodule