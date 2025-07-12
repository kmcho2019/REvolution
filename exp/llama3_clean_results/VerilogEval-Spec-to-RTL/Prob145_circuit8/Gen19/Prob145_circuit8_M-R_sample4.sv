module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg [1:0] count; // Counter for consecutive 'a' high cycles
reg prev_q; // Previous value of 'q'

always @(posedge clock) begin
    p <= a; // 'p' is high only when 'a' is high
    if (a) begin // 'a' is high
        count <= count + 1; // Increment counter
        if (count == 2) begin // Two consecutive 'a' high cycles
            prev_q <= 1'b1; // Set 'q' high
        end
    end else begin // 'a' is low
        count <= 0; // Reset counter
        prev_q <= 0; // Reset 'q'
    end
end

assign q = prev_q || (prev_q && a); // 'q' remains high until 'a' goes low and clock goes low

endmodule