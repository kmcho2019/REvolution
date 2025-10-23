module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {A=2'd0, B0=2'd1, B1=2'd2, B2=2'd3} state_t;
    state_t state, next_state;

    reg [1:0] count;   // counts number of w=1 in current group (0..3)
    reg z_next;        // output to be loaded into z at B0 (one cycle after sampling)

    // State and output sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state  <= A;
            count  <= 2'd0;
            z      <= 1'b0;
            z_next <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    z <= 1'b0;
                    count <= 2'd0;
                    z_next <= 1'b0;
                end

                B0: begin
                    // Output the previous group's result
                    z <= z_next;
                    // Start new counting with current w
                    count <= (w ? 2'd1 : 2'd0);
                    // Clear z_next to prepare for next group
                    z_next <= 1'b0;
                end

                B1: begin
                    count <= count + (w ? 2'd1 : 2'd0);
                end

                B2: begin
                    count <= count + (w ? 2'd1 : 2'd0);
                    // Compute z_next for next cycle output
                    z_next <= ((count + (w ? 2'd1 : 2'd0)) == 2);
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A:  next_state = (s) ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B0;
            default: next_state = A;
        endcase
    end

endmodule