module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// ROM implementation using case statement
reg [3:0] arrow_rom;

always @(*) begin
    case (scancode)
        16'he06b: arrow_rom = 4'b1000; // left
        16'he072: arrow_rom = 4'b0100; // down
        16'he074: arrow_rom = 4'b0010; // right
        16'he075: arrow_rom = 4'b0001; // up
        default:  arrow_rom = 4'b0000; // none
    endcase
end

// Assign outputs from ROM bits
assign left  = arrow_rom[3];
assign down  = arrow_rom[2];
assign right = arrow_rom[1];
assign up    = arrow_rom[0];

endmodule