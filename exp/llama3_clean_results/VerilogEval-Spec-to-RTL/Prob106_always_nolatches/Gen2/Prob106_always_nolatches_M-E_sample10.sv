module TopModule(
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

wire [3:0] decoded;

// Create a 16-to-4 decoder
always @(*) begin
    case (scancode)
        16'he06b: decoded = 4'b0001; // left
        16'he072: decoded = 4'b0010; // down
        16'he074: decoded = 4'b0100; // right
        16'he075: decoded = 4'b1000; // up
        default: decoded = 4'b0000; // none
    endcase
end

// Assign outputs based on decoded value
assign left  = decoded[0];
assign down  = decoded[1];
assign right = decoded[2];
assign up    = decoded[3];

endmodule