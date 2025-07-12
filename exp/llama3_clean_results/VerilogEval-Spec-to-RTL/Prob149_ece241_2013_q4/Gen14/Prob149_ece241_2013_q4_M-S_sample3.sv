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
        // Reset to state equivalent to low water level
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Store previous sensor state
        prev_s <= s;
    end
end

// Combinational logic to determine output signals (fr2, fr1, fr0) and dfr
always @(*) begin
    if (s[2]) begin
        fr2 <= 1'b0;
        fr1 <= 1'b0;
        fr0 <= 1'b0;
        dfr <= 1'b0;
    end else if (s[1]) begin
        fr2 <= 1'b0;
        fr1 <= 1'b0;
        fr0 <= 1'b1;
        dfr <= (s > prev_s);
    end else if (s[0]) begin
        fr2 <= 1'b0;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= (s > prev_s);
    end else begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= (s > prev_s);
    end
end

endmodule