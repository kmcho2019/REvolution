module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [8:0] counter;  // 9-bit counter for 512 positions
    wire [511:0] left_neighbor = {q[510:0], 1'b0};
    wire [511:0] right_neighbor = {1'b0, q[511:1]};
    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            counter <= 9'd0;
        end else begin
            // Generate next state for current bit position
            next_q = q;
            next_q[counter] = left_neighbor[counter] ^ right_neighbor[counter];
            
            // Update just one bit per cycle
            q <= next_q;
            
            // Advance counter
            counter <= counter + 1;
        end
    end

endmodule