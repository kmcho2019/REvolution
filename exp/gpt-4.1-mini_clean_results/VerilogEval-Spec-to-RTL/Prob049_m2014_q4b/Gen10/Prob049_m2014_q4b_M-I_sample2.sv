module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

// Synchronize asynchronous reset release to clk domain
reg ar_sync1, ar_sync2;
wire ar_sync;

// Capture asynchronous reset assertion immediately
always @(posedge clk or posedge ar) begin
    if (ar) begin
        ar_sync1 <= 1'b1;
        ar_sync2 <= 1'b1;
    end else begin
        ar_sync1 <= 1'b0;
        ar_sync2 <= ar_sync1;
    end
end

assign ar_sync = ar_sync2;

// DFF with asynchronous reset on assertion, synchronized reset release
always @(posedge clk or posedge ar) begin
    if (ar)         // Async reset assertion immediate
        q <= 1'b0;
    else if (~ar_sync) // After reset release synchronized
        q <= d;
    else
        q <= q;   // Hold value during synchronized reset release to avoid toggling
end

endmodule