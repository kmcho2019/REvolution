module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// To reduce area and power, ensure that the clock is only enabled when necessary
// This can be achieved by using a clock enable signal that is derived from E and L
// However, in this simple design, the benefit might be minimal and could introduce additional complexity

always @(posedge clk) begin
    if (L) begin
        Q <= R; // Load operation
    end else if (E) begin
        Q <= w; // Shift operation
    end else begin
        // Q remains the same if neither load nor shift is enabled
        Q <= Q;
    end
end

// An alternative implementation with a clock enable could look like this:
// However, without a specific synthesis tool and technology, this might not provide benefits
// wire clk_en;
// assign clk_en = L || E;
// always @(posedge clk) begin
//     if (clk_en) begin
//         if (L) begin
//             Q <= R;
//         end else begin
//             Q <= w;
//         end
//     end
// end

endmodule