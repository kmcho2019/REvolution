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

    // Next state and counter logic
    wire next_state = (state == A) ? (s ? B : A) : B;
    wire [1:0] next_cycle_count = (state == B) ? 
                                 (cycle_count == 2'd2 ? 2'd0 : cycle_count + 1'b1) : 
                                 2'd0;
    wire [1:0] next_ones_count = (state == B) ? 
                                (cycle_count == 2'd0 ? w : ones_count + w) : 
                                2'd0;

    // Output logic
    assign z = (state == B) && (cycle_count == 2'd0) && (ones_count == 2'd2);

    // Sequential updates
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            ones_count <= 2'd0;
        end else begin
            state <= next_state;
            cycle_count <= next_cycle_count;
            ones_count <= next_ones_count;
        end
    end

endmodule