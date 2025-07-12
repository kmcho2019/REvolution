module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Using if-else conditions to implement the logic
always @(*) begin
    if (a) begin
        out = 1'b1;
    end else if (!b && c) begin
        out = 1'b1;
    end else begin
        out = 1'b0;
    end
end

// Alternatively, using a case statement (though not directly applicable here due to the nature of the conditions)
// always @(*) begin
//     case ({a, b, c})
//         // Conditions to make out = 1
//         3'b100, 3'b101, 3'b110, 3'b111, 3'b010: out = 1'b1;
//         default: out = 1'b0;
//     endcase
// end

endmodule