module TopModule (
    input  clk,
    input  ar,    // asynchronous active-high reset
    input  d,
    output reg q
);

    reg ar_sync1, ar_sync2;

    // Synchronize asynchronous reset to clk domain to create synchronous reset release
    always @(posedge clk or posedge ar) begin
        if (ar) begin
            ar_sync1 <= 1'b1;
            ar_sync2 <= 1'b1;
        end else begin
            ar_sync1 <= 1'b0;
            ar_sync2 <= ar_sync1;
        end
    end

    // Use synchronous reset derived from ar_sync2 for flip-flop reset
    always @(posedge clk) begin
        if (ar_sync2) 
            q <= 1'b0;
        else 
            q <= d;
    end

endmodule