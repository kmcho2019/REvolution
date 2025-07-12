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
    reg rising;

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
            rising <= 1'b1;
        end else begin
            // Detect rising water (any new sensor triggered)
            rising <= (s[0] & ~prev_s[0]) | 
                     (s[1] & ~prev_s[1]) | 
                     (s[2] & ~prev_s[2]);
            prev_s <= s;
        end
    end

    // Output logic
    assign fr0 = reset ? 1'b1 : (s != 3'b111);
    assign fr1 = reset ? 1'b1 : (s == 3'b001 || s == 3'b000);
    assign fr2 = reset ? 1'b1 : (s == 3'b000);
    assign dfr = reset ? 1'b1 : rising;

endmodule