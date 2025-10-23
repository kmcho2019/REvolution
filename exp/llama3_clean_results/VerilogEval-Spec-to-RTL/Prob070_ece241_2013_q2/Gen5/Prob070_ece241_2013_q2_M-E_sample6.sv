module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Implementing the SOP and POS logic using lookup tables
reg [1:0] lut_sop [15:0];
reg [1:0] lut_pos [15:0];

integer i;
initial begin
    for (i = 0; i < 16; i++) begin
        case (i)
            2, 7, 15: lut_sop[i] = 2'b01; // Logic-1 for SOP
            default:  lut_sop[i] = 2'b00; // Logic-0 for SOP
        endcase
        
        case (i)
            0, 1, 4, 5, 6, 9, 10, 13, 14: lut_pos[i] = 2'b00; // Logic-0 for POS
            default: lut_pos[i] = 2'b01; // Logic-1 for POS (including 2, 7, 15)
        endcase
    end
end

// Generate the output based on the input conditions using the LUTs
always @(a, b, c, d) begin
    reg [3:0] addr;
    addr = {a, b, c, d};
    out_sop = lut_sop[addr][0];
    out_pos = lut_pos[addr][0];
end

endmodule