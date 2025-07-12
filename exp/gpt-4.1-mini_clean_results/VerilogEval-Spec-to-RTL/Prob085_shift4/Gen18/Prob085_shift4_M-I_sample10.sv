module TopModule (
    input         clk,
    input         areset,
    input         load,
    input         ena,
    input  [3:0]  data,
    output reg [3:0] q
);

// Sequential logic with asynchronous positive-edge reset
always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else begin
        if (load)
            q <= data;                 // Load has highest priority
        else if (ena)
            q <= q >> 1;               // Shift right, MSB fills with 0
        // else hold current q (no assignment needed)
    end
end

endmodule