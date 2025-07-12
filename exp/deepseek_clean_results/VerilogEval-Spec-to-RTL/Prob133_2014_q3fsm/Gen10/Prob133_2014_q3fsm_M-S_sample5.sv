module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    // Combined cycle counter and 1's counter
    // [1:0] = cycle count (0-2)
    // [3:2] = 1's count (0-3)
    reg [3:0] counter;

    // Next state logic
    wire next_state = (state == STATE_A) ? (s ? STATE_B : STATE_A) : STATE_B;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            counter <= 4'b0;
        end else begin
            state <= next_state;
            
            if (state == STATE_B) begin
                // Update cycle counter (modulo 3)
                if (counter[1:0] == 2'b10) begin
                    counter[1:0] <= 2'b00;
                end else begin
                    counter[1:0] <= counter[1:0] + 1'b1;
                end
                
                // Update 1's counter when w is 1
                if (w) begin
                    counter[3:2] <= counter[3:2] + 1'b1;
                end
            end else begin
                // Reset counters in state A
                counter <= 4'b0;
            end
        end
    end

    // Output logic - check if we have exactly two 1's at cycle 0
    assign z = (state == STATE_B) && (counter[1:0] == 2'b00) && (counter[3:2] == 2'b10);

endmodule