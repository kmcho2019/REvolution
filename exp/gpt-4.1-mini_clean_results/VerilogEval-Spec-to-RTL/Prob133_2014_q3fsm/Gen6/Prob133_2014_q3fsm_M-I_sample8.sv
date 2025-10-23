module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: 2 bits for 4 states
    localparam A   = 2'd0; // Waiting for s=1
    localparam B_0 = 2'd1; // 1st cycle in counting window
    localparam B_1 = 2'd2; // 2nd cycle in counting window
    localparam B_2 = 2'd3; // 3rd cycle in counting window

    reg [1:0] state, next_state;
    reg [1:0] w_count;        // saturating counter for number of w=1 samples (max 3)
    reg z_next;               // next z output value, updated synchronously

    // Next state logic combinational block
    always @(*) begin
        case(state)
            A:   next_state = s ? B_0 : A;
            B_0: next_state = B_1;
            B_1: next_state = B_2;
            B_2: next_state = B_0;
            default: next_state = A;
        endcase
    end

    // Sequential logic: state, w_count, and z update on posedge clk
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
            z_next <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    w_count <= 2'd0;
                    z <= 1'b0;
                    z_next <= 1'b0;
                end

                B_0, B_1: begin
                    // Increment w_count if w=1, saturate at 3
                    if (w && w_count != 2'd3)
                        w_count <= w_count + 1'b1;
                    // else hold current count

                    z <= 1'b0;        // output zero while sampling
                    z_next <= 1'b0;
                end

                B_2: begin
                    // Increment w_count if w=1, saturate at 3
                    if (w && w_count != 2'd3)
                        w_count <= w_count + 1'b1;
                    else
                        w_count <= w_count;

                    // Compute output z_next for next cycle: z=1 if exactly two w=1 samples in last 3 cycles
                    // w_count now includes first two w=1 samples; current w may add one more
                    // But here w_count before adding w represents samples in B_0 and B_1
                    // Because state changes after this clock, adding w here is same as after counting third sample

                    // So sum = w_count + w (max 3), check if equals 2
                    z_next <= ((w_count + w) == 2);

                    // Output z is registered one cycle after counting window, update z to previous z_next
                    z <= z_next;
                end

                default: begin
                    w_count <= 2'd0;
                    z <= 1'b0;
                    z_next <= 1'b0;
                end
            endcase
        end
    end

endmodule