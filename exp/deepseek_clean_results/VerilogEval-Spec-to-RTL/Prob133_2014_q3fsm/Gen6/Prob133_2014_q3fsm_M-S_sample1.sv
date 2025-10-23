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
    reg has_two_ones;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            has_two_ones <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        cycle_count <= 2'd0;
                        has_two_ones <= 1'b0;
                    end
                end
                B: begin
                    if (cycle_count == 2'd2) begin
                        cycle_count <= 2'd0;
                        has_two_ones <= (w ? !has_two_ones : has_two_ones);
                    end else begin
                        cycle_count <= cycle_count + 1;
                        if (w) has_two_ones <= !has_two_ones;
                    end
                end
            endcase
        end
    end

    assign z = (state == B) && (cycle_count == 2'd2) && has_two_ones;

endmodule