module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A  = 2'd0; // wait for s=1
    localparam B0 = 2'd1; // 1st w sample cycle
    localparam B1 = 2'd2; // 2nd w sample cycle
    localparam B2 = 2'd3; // 3rd w sample cycle

    reg [1:0] state, next_state;
    reg [1:0] count;       // counts number of w=1 in current group (0..3)
    reg       z_out;       // stores output corresponding to previous group result

    // Sequential logic: state and count update, output register update
    always @(posedge clk) begin
        if (reset) begin
            state  <= A;
            count  <= 0;
            z_out  <= 0;
            z      <= 0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    // Stay in A until s=1
                    count <= 0;
                    z_out <= 0;
                end

                B0: begin
                    // Start new group: reset count and accumulate current w
                    count <= (w ? 1 : 0);
                    // z_out unchanged here (holds previous group output)
                end

                B1: begin
                    // Accumulate second sample
                    count <= count + (w ? 1 : 0);
                    // z_out unchanged
                end

                B2: begin
                    // Accumulate third sample
                    count <= count + (w ? 1 : 0);
                    // After accumulating all three samples, update z_out for next cycle
                    z_out <= (count + (w ? 1 : 0) == 2) ? 1'b1 : 1'b0;
                end

                default: begin
                    state <= A;
                    count <= 0;
                    z_out <= 0;
                end
            endcase

            // Output assignment: output the stored result of previous group
            z <= z_out;
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            A:  next_state = (s == 1'b1) ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B0;
            default: next_state = A;
        endcase
    end

endmodule