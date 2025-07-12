module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

reg [6:0] ring_counter;

always @(posedge clk) begin
    if (load) begin
        ring_counter <= 0;
        q <= data;
    end else begin
        case (ena)
            2'b01: begin
                // Rotate right by one bit
                ring_counter <= ring_counter - 1;
            end
            2'b10: begin
                // Rotate left by one bit
                ring_counter <= ring_counter + 1;
            end
            default: begin
                // Do not rotate
                ring_counter <= ring_counter;
            end
        endcase
        
        // Use the ring counter to select the bits
        for (int i = 0; i < 100; i++) begin
            if (i == ring_counter) begin
                q[i] <= q[99];
            end else if (i == (ring_counter + 1) % 100) begin
                q[i] <= q[0];
            end else begin
                q[i] <= q[i];
            end
        end
    end
end

endmodule