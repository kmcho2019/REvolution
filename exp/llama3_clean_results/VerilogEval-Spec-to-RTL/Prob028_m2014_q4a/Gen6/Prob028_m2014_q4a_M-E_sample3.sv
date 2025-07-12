module TopModule(
    input  d,
    input  ena,
    output reg q
);
reg prev_ena;

always @(posedge ena or negedge ena) begin
    if (ena) begin
        q <= d; // Use non-blocking assignment for sequential behavior
    end else begin
        // Do nothing, q retains its previous value
    end
end

always @(posedge ena) begin
    prev_ena <= ena;
end

endmodule