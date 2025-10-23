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

    // Counting registers
    reg [1:0] cycle_count;
    reg [1:0] ones_count;

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Window completion signal
    wire window_done = (cycle_count == 2'd2);

    // Output logic
    assign z = (state == B) && window_done && (ones_count == 2'd2);

    // State transition
    always @(posedge clk) state <= reset ? A : next_state;

    // Cycle counter update
    always @(posedge clk) begin
        if (reset) cycle_count <= 2'b00;
        else if (state == B) 
            cycle_count <= window_done ? 2'd0 : (cycle_count + 1'b1);
        else 
            cycle_count <= 2'b00;
    end

    // Ones counter update
    always @(posedge clk) begin
        if (reset) ones_count <= 2'b00;
        else if (state == B) begin
            if (window_done)
                ones_count <= w;
            else
                ones_count <= ones_count + w;
        end else
            ones_count <= 2'b00;
    end

endmodule