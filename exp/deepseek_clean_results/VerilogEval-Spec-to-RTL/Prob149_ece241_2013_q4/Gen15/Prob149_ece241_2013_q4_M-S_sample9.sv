module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] prev_s;  // Track previous sensor state

    // Output assignments
    assign fr0 = reset ? 1'b1 : (s != 3'b111);  // On unless above s[2]
    assign fr1 = reset ? 1'b1 : (s == 3'b001 || s == 3'b000);
    assign fr2 = reset ? 1'b1 : (s == 3'b000);
    
    // DFR is 1 if water is rising (current s > previous s)
    assign dfr = reset ? 1'b1 : (s > prev_s && s != 3'b111);

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;  // Assume was below s[0]
        end else begin
            prev_s <= s;
        end
    end

endmodule