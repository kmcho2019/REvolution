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

// Combinational logic to determine output signals
assign fr2 = (s[0] == 1'b0) && (s[1] == 1'b0) && (s[2] == 1'b0);
assign fr1 = (s[0] == 1'b1) && (s[1] == 1'b0) && (s[2] == 1'b0) || (s[0] == 1'b0) && (s[1] == 1'b0) && (s[2] == 1'b0);
assign fr0 = (s[0] == 1'b1) && (s[1] == 1'b0) && (s[2] == 1'b0) || (s[0] == 1'b0) && (s[1] == 1'b0) && (s[2] == 1'b0) || (s[1] == 1'b1) && (s[2] == 1'b0);

// Determine supplemental flow rate signal (dfr)
always @(posedge clk) begin
    if (reset) begin
        dfr <= 1'b1;
    end else begin
        case ({s, prev_s})
            7'b000_000, 7'b000_001, 7'b000_010, 7'b000_011, 7'b000_100, 7'b000_101, 7'b000_110, 7'b000_111,
            7'b001_000, 7'b001_001, 7'b001_010, 7'b001_011, 7'b001_100, 7'b001_101, 7'b001_110, 7'b001_111,
            7'b010_000, 7'b010_001, 7'b010_010, 7'b010_011, 7'b010_100, 7'b010_101, 7'b010_110, 7'b010_111,
            7'b011_000, 7'b011_001, 7'b011_010, 7'b011_011, 7'b011_100, 7'b011_101, 7'b011_110, 7'b011_111: dfr <= 1'b0;
            default: dfr <= 1'b1;
        endcase
    end
end

endmodule