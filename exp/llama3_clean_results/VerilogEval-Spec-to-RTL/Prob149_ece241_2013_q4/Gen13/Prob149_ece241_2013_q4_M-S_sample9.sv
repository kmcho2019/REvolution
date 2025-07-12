module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s; // Register to store previous sensor state

// Sequential logic to update previous sensor state
always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
    end
end

// Combinational logic to determine output signals (fr2, fr1, fr0) and dfr
always @(*) begin
    if (reset) begin
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
        dfr = 1'b1;
    end else begin
        fr2 = ~(s[2] || s[1] || s[0]);
        fr1 = ~(s[2] || s[1]);
        fr0 = ~s[2];
        dfr = (s > prev_s) && (s != 3'b000);
    end
end

endmodule