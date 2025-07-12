module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam A = 1'b0,
               B = 1'b1;

    reg state;
    reg [1:0] cycle_count;
    reg [1:0] w_count;

    // Sequential logic: state and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                    z <= 1'b0; // hold z low in A
                    if (s)
                        state <= B;
                end
                B: begin
                    if (cycle_count == 2) begin
                        cycle_count <= 2'd0;
                        w_count <= (w == 1'b1) ? 2'd1 : 2'd0;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                        if (w == 1'b1)
                            w_count <= w_count + 1'b1;
                    end
                    state <= B; // remain in B
                    z <= 1'b0;  // default low, will be set combinationally next
                end
            endcase
        end
    end

    // Combinational logic for output z: set only when in B and at end of counting cycle with exactly two w's
    always @(*) begin
        if (state == B && cycle_count == 2 && (w_count + w == 2))
            z = 1'b1;
        else
            z = 1'b0;
    end

endmodule