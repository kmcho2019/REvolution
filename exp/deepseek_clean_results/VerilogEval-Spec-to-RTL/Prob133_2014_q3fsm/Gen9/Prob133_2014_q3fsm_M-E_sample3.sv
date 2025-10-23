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

    // Shift register for last 3 w values
    reg [2:0] w_history;

    // Next state logic (combinational)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic - true when exactly two 1's in w_history
    assign z = (state == B) && (
               (w_history == 3'b011) ||
               (w_history == 3'b101) ||
               (w_history == 3'b110));

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Shift in new w value
                w_history <= {w_history[1:0], w};
            end else begin
                // Reset shift register in state A
                w_history <= 3'b000;
            end
        end
    end

endmodule