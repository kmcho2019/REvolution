module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam A  = 2'd0;
    localparam B0 = 2'd1;
    localparam B1 = 2'd2;
    localparam B2 = 2'd3;

    reg [1:0] state, next_state;
    reg [1:0] count;   // counts number of w=1 in 3 cycles
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_next;
            // Update count in B states
            if (state == B0) begin
                count <= w ? 2'd1 : 2'd0;
            end else if (state == B1) begin
                count <= count + (w ? 1 : 0);
            end else if (state == B2) begin
                count <= count + (w ? 1 : 0);
            end else begin
                count <= 2'd0;
            end
        end
    end

    always @(*) begin
        // Default assignments
        next_state = state;
        z_next = 1'b0;

        case(state)
            A: begin
                z_next = 1'b0;
                if (s == 1'b1)
                    next_state = B0;
                else
                    next_state = A;
            end

            B0: begin
                next_state = B1;
                z_next = 1'b0; // no output in counting cycles
            end

            B1: begin
                next_state = B2;
                z_next = 1'b0;
            end

            B2: begin
                // After 3rd w sample, output z=1 if count + current w = 2
                // count so far is count (2 cycles), add current w
                if ((count + (w ? 1 : 0)) == 2)
                    z_next = 1'b1;
                else
                    z_next = 1'b0;
                next_state = B0; // repeat the 3-cycle checking
            end

            default: begin
                next_state = A;
                z_next = 1'b0;
            end
        endcase
    end

endmodule