module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

// Asynchronous reset
always @(ar) begin
    if(ar) begin
        q <= 0;
    end
end

// Synchronous, clocked logic
always @(posedge clk) begin
    if(!ar) begin // Only update if ar is not asserted
        q <= d;
    end
end

endmodule