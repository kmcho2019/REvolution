module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg [1:0] count; // Combines cycle count (bits[1:0]) and 1's count (bit[1])

    // State transition
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output is high when in state B, at end of 3-cycle window, and exactly two 1's seen
    assign z = (state == B) && (count == 2'b10);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'b00;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update count: bits[1] tracks 1's count, bits[0] tracks cycle
                count <= {count[1] ^ (count[0] & w), ~count[0]};
            end else begin
                count <= 2'b00;
            end
        end
    end

endmodule