module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care
    output reg out
);

// Using c and d as select signals for a 4-to-1 mux
// The mux inputs are determined by a and b to match the Karnaugh map outputs.
// Map the Karnaugh table as per cd selects and ab inputs.

// We'll map:
// select = {c,d}
// For each select, assign out based on ab values per Karnaugh map rows

always @(*) begin
    case ({c,d})
        2'b00: // cd=00, row in Karnaugh map
            case ({a,b})
                2'b00: out = 0; // ab=00
                2'b01: out = 1; // ab=01
                2'b10: out = 1; // ab=10
                2'b11: out = 1; // ab=11
                default: out = 1'bx;
            endcase
        2'b01: // cd=01
            case ({a,b})
                2'b00: out = 0;
                2'b01: out = 0;
                2'b10: out = 1'bx; // d=don't care
                2'b11: out = 1'bx; // d=don't care
                default: out = 1'bx;
            endcase
        2'b11: // cd=11
            case ({a,b})
                2'b00: out = 1;
                2'b01: out = 1;
                2'b10: out = 1;
                2'b11: out = 0;
                default: out = 1'bx;
            endcase
        2'b10: // cd=10
            case ({a,b})
                2'b00: out = 1;
                2'b01: out = 1;
                2'b10: out = 1;
                2'b11: out = 0;
                default: out = 1'bx;
            endcase
        default: out = 1'bx;
    endcase
end

endmodule