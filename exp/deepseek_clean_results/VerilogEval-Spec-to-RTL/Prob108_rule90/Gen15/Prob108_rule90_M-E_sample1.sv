module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
reg [511:0] next_q;
reg [8:0] counter;  // 9 bits to count up to 511
reg [2:0] window;   // 3-bit sliding window (left, center, right)

always @(posedge clk) begin
    if (load) begin
        q <= data;
        counter <= 0;
    end else begin
        // Update sliding window
        window[0] <= (counter == 0) ? 1'b0 : q[counter-1];  // left neighbor
        window[1] <= q[counter];                            // current cell
        window[2] <= (counter == WIDTH-1) ? 1'b0 : q[counter+1];  // right neighbor
        
        // Compute next state for current position
        next_q[counter] <= window[0] ^ window[2];
        
        // Update output and counter
        q <= next_q;
        counter <= (counter == WIDTH-1) ? 0 : counter + 1;
    end
end

endmodule