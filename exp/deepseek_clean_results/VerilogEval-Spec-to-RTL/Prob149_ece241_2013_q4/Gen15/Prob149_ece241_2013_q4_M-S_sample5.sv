module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [1:0] prev_level;  // 00:below_s0, 01:s1_to_s0, 10:s2_to_s1, 11:above_s2

    // Current level detection
    wire [1:0] curr_level = s[2] ? 2'b11 : 
                           s[1] ? 2'b10 : 
                           s[0] ? 2'b01 : 2'b00;

    // Output assignments
    assign fr0 = reset ? 1'b1 : (curr_level != 2'b11);
    assign fr1 = reset ? 1'b1 : (curr_level <= 2'b01);
    assign fr2 = reset ? 1'b1 : (curr_level == 2'b00);
    assign dfr = reset ? 1'b1 : ((curr_level > prev_level) && (curr_level != 2'b11));

    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'b00;
        end else begin
            prev_level <= curr_level;
        end
    end

endmodule