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

    // Shift register for window tracking
    reg [2:0] w_window;

    // State transition logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Combinational logic for counting 1's in window
    wire [1:0] ones_count = w_window[0] + w_window[1] + w_window[2];

    // Output logic - active when window is full and exactly two 1's
    assign z = (state == B) && (&w_window) && (ones_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_window <= 3'b000;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Shift in new w value and shift out oldest
                w_window <= {w_window[1:0], w};
            end else begin
                // Clear window when in state A
                w_window <= 3'b000;
            end
        end
    end

endmodule