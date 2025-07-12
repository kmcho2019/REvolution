module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg d_pos;  // Sampled on posedge clk
    reg d_neg;  // Sampled on negedge clk

    // Sample input d at positive clock edge
    always @(posedge clk) begin
        d_pos <= d;
    end

    // Sample d_pos at negative clock edge
    always @(negedge clk) begin
        d_neg <= d_pos;
    end

    // Output toggles at every clock edge if d was high
    always @(posedge clk or negedge clk) begin
        // The combination of d_pos and d_neg changes at every edge d is high
        // XOR of the two sampled values indicates a toggle condition
        q <= d_pos ^ d_neg;
    end

endmodule