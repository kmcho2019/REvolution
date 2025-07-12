module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // States
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking
    reg [1:0] cycle_count;
    reg ones_count;

    // Output logic
    assign z = (state == B) && (cycle_count == 2'd2) && (ones_count == 1'b1);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            ones_count <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        cycle_count <= 2'd0;
                        ones_count <= 1'b0;
                    end
                end
                B: begin
                    if (cycle_count == 2'd2) begin
                        // End of window - reset for next window
                        cycle_count <= 2'd0;
                        ones_count <= w;
                    end else begin
                        cycle_count <= cycle_count + 1;
                        ones_count <= ones_count + w;
                    end
                end
            endcase
        end
    end

endmodule