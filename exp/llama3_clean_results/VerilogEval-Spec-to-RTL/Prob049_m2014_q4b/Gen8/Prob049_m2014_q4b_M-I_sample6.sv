module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Explicitly set to 0 for clarity and to avoid any potential issues with uninitialized values
    end else if (posedge clk) begin // This condition is implicitly true due to the sensitivity list, but kept for clarity
        q <= d;
    end
end

endmodule