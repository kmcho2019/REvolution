module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam [2:0]
        A  = 3'b000,
        B0 = 3'b001,
        B1 = 3'b010,
        B2 = 3'b011;

    reg [2:0] state, next_state;
    reg [1:0] w_count; // Counts how many times w=1 in 3 cycles
    reg z_next;

    // Next state and combinational outputs logic
    always @(*) begin
        next_state = state;
        z_next = 1'b0;

        case (state)
            A: begin
                if (s)
                    next_state = B0;
            end
            B0: begin
                next_state = B1;
            end
            B1: begin
                next_state = B2;
            end
            B2: begin
                next_state = B0;
                // Output z_next=1 if exactly 2 w=1 in this group (including current w)
                // but the count is updated in sequential always block
            end
            default: next_state = A;
        endcase
    end

    // Sequential logic: state, w_count, and output register updates
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_next;

            case (state)
                A: w_count <= 2'd0;
                B0: w_count <= w ? 2'd1 : 2'd0;
                B1: w_count <= w_count + (w ? 1'b1 : 1'b0);
                B2: begin
                    // After receiving the last w, decide on z
                    // The count is w_count + current w (0 or 1)
                    // Because at B2 we have only 2 cycles accumulated so far:
                    // Actually, w_count stores count of first two cycles:
                    // B0 stores first w, B1 adds second w, now B2 w is added here

                    // Calculate final count including current w:
                    // Use a temporary variable
                    integer total_count;
                    total_count = w_count + (w ? 1 : 0);
                    // Set z based on total_count == 2
                    z <= (total_count == 2) ? 1'b1 : 1'b0;

                    w_count <= 2'd0; // Reset count for next group
                end
                default: w_count <= 2'd0;
            endcase
        end
    end

endmodule