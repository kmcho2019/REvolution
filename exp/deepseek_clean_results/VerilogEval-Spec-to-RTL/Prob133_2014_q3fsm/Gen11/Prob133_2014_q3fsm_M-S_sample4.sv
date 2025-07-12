module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Combined counter: bits [1:0] for cycle count, bit [2] for 1's count
    reg [2:0] counter;

    // State transition
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic - true when in B, at start of window, and exactly two 1's counted
    assign z = (state == B) && (counter[1:0] == 2'd0) && (counter[2] == 1'b1);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            counter <= 3'b000;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update cycle counter (bits [1:0])
                counter[1:0] <= (counter[1:0] == 2'd2) ? 2'd0 : (counter[1:0] + 1'b1);
                
                // Update 1's count (bit [2]) - reset at window start
                if (counter[1:0] == 2'd0)
                    counter[2] <= w;
                else
                    counter[2] <= counter[2] ^ w; // Toggle if odd number of 1's
            end else begin
                // Reset counter in state A
                counter <= 3'b000;
            end
        end
    end

endmodule