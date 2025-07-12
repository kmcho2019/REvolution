module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State definitions
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking
    reg [1:0] cycle_count;
    reg [1:0] ones_count;

    // Next state and counter values
    wire next_state;
    wire [1:0] next_cycle_count;
    wire [1:0] next_ones_count;

    // State transition logic
    assign next_state = (state == A) ? (s ? B : A) : B;

    // Counter logic
    assign next_cycle_count = (state == B) ? 
                            ((cycle_count == 2'd2) ? 2'd0 : cycle_count + 1) : 
                            2'd0;
    
    assign next_ones_count = (state == B) ?
                           ((cycle_count == 2'd2) ? w : ones_count + w) :
                           2'd0;

    // Output logic - active when window ends with exactly two 1's
    assign z = (state == B) && (cycle_count == 2'd2) && (ones_count + w == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            ones_count <= 2'd0;
        end else begin
            state <= next_state;
            cycle_count <= next_cycle_count;
            ones_count <= (state == B && cycle_count == 2'd2) ? w : next_ones_count;
        end
    end

endmodule