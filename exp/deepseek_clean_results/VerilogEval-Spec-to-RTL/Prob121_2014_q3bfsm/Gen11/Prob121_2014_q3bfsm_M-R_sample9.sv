module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot encoded state registers (5 states)
    reg s000, s001, s010, s011, s100;

    // Next state logic as continuous assignments
    wire next_s000 = (~reset) & ((~x & s000) | (x & s010 & ~s011));
    wire next_s001 = (~reset) & ((x & s000) | (~x & s001) | (x & s010) | (~x & s011));
    wire next_s010 = (~reset) & ((x & s011) | (~x & s010) | (~x & s100));
    wire next_s011 = (~reset) & (~x & s100);
    wire next_s100 = (~reset) & ((x & s001) | (x & s100));

    // State register updates
    always @(posedge clk) begin
        s000 <= reset ? 1'b1 : next_s000;
        s001 <= reset ? 1'b0 : next_s001;
        s010 <= reset ? 1'b0 : next_s010;
        s011 <= reset ? 1'b0 : next_s011;
        s100 <= reset ? 1'b0 : next_s100;
    end

    // Output logic - z=1 when in state 011 or 100
    assign z = s011 | s100;

endmodule