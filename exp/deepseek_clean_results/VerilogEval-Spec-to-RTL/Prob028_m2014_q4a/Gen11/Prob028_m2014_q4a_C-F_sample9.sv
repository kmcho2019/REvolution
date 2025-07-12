module TopModule (
    input d,
    input ena,
    output reg q
);

// synthesis attribute latch of q is "yes"
/* Latch behavior:
   - When ena is high, q follows d (transparent)
   - When ena is low, q holds its previous value
*/
always @(ena or d) begin
    if (ena) q = d;
end

endmodule