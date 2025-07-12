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

    // Track previous sensor state
    always @(posedge clk) begin
        if (reset)
            prev_s <= 3'b000;
        else
            prev_s <= s;
    end

    // Output assignments
    assign fr2 = reset ? 1'b1 : ~(|s);               // All sensors off
    assign fr1 = reset ? 1'b1 : (s == 3'b001);       // Only s[0] on
    assign fr0 = reset ? 1'b1 : (s[1:0] != 2'b00);   // Any sensor below s[2] on
    assign dfr = reset ? 1'b1 : (s > prev_s);        // Water level rising

endmodule