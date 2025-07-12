module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output reg [15:0] out
);

// Early detection of invalid selection (sel >= 9)
wire invalid_sel = sel[3] & sel[2];

// First level mux groups
wire [15:0] group0_out, group1_out, group2_out;

// Group 0: a-d (sel[1:0] selects within group)
assign group0_out = (sel[1:0] == 2'b00) ? a :
                    (sel[1:0] == 2'b01) ? b :
                    (sel[1:0] == 2'b10) ? c : d;

// Group 1: e-h (sel[1:0] selects within group)
assign group1_out = (sel[1:0] == 2'b00) ? e :
                    (sel[1:0] == 2'b01) ? f :
                    (sel[1:0] == 2'b10) ? g : h;

// Group 2: i only (special case)
assign group2_out = i;

// Final selection based on sel[3:2]
always @(*) begin
    if (invalid_sel) begin
        out = 16'hFFFF;  // Default for invalid cases
    end else begin
        case (sel[3:2])
            2'b00: out = group0_out;  // a-d
            2'b01: out = group1_out;  // e-h
            2'b10: out = group2_out;  // i
            default: out = 16'hFFFF;  // redundant but safe
        endcase
    end
end

endmodule