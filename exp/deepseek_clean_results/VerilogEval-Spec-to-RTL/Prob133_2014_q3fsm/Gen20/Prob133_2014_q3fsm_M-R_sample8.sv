module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg current_state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Counting registers
    reg [1:0] window_cycle;
    reg [1:0] w_ones_count;

    // Next state logic (continuous assignment)
    wire next_state = (current_state == A) ? (s ? B : A) : B;

    // Window cycle counter logic
    wire [1:0] next_window_cycle = 
        (reset || current_state == A) ? 2'b00 :
        (window_cycle == 2'd2) ? 2'd0 :
        window_cycle + 1'b1;

    // Ones counter logic
    wire [1:0] next_w_ones_count = 
        (reset || current_state == A) ? 2'b00 :
        (window_cycle == 2'd0) ? w :
        w_ones_count + w;

    // Output logic - active when window completes with exactly two 1's
    assign z = (current_state == B) && (window_cycle == 2'd0) && (w_ones_count == 2'd2);

    // Sequential updates
    always @(posedge clk) begin
        current_state <= next_state;
        window_cycle <= next_window_cycle;
        w_ones_count <= next_w_ones_count;
    end

endmodule