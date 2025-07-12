module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

reg ar_sync1, ar_sync2;

// Synchronize asynchronous reset release to clock domain
always @(posedge clk or posedge ar) begin
    if (ar) begin
        ar_sync1 <= 1'b1;
        ar_sync2 <= 1'b1;
    end else begin
        ar_sync1 <= 1'b0;
        ar_sync2 <= ar_sync1;
    end
end

// D flip-flop with async assertion but synchronous release of reset
// When 'ar' is asserted, q asynchronously resets to 0 immediately
// When 'ar' is deasserted, q releases reset only after synchronization (ar_sync2 deasserted)
always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;       // async reset assert
    else if (~ar_sync2)  
        q <= d;          // update q only after reset is synchronously released
end

endmodule