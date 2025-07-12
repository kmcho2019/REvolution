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

    // Combined counter: [2] is cycle phase (0-1-2), [1:0] counts 'w's
    reg [2:0] counter;

    // Next state is B when in A and s=1, otherwise stay in current state
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output is high when in B, at end of cycle (counter[2]), and exactly two 'w's
    assign z = (state == B) && (counter == 3'b100);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            counter <= 3'b000;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update counter: increment phase and count 'w's
                counter <= {counter[1:0] + w, ~counter[2]};
            end else begin
                // Reset counter in state A
                counter <= 3'b000;
            end
        end
    end

endmodule