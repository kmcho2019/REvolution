module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum logic {A, B} state_t;
    state_t state, next_state;

    // Shift register to store last three w values in B
    reg [2:0] w_shift;

    // Flag indicating output z should be asserted next cycle
    reg z_next;

    // Sequential logic: state and w_shift updates
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_shift <= 3'b0;
            z <= 1'b0;
            z_next <= 1'b0;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Shift in current w
                w_shift <= {w_shift[1:0], w};
            end else begin
                // In state A, clear w_shift
                w_shift <= 3'b0;
            end

            // Output register update: z asserted when z_next is set
            z <= z_next;
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            A: next_state = (s == 1'b1) ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    // Compute z_next combinationally based on w_shift length
    // Only assert z_next if in B and after every 3 shifts
    // We track count implicitly by checking when w_shift is fully filled
    // To track the 3-cycle window, assert z after every third input in B
    reg cycle_tick; // goes high every 3 cycles in B

    // Use a counter to track cycles modulo 3 in B
    reg [1:0] cycle_counter;
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 2'd0;
        end else if (state == B) begin
            if (cycle_counter == 2)
                cycle_counter <= 2'd0;
            else
                cycle_counter <= cycle_counter + 1;
        end else begin
            cycle_counter <= 2'd0;
        end
    end

    always @(*) begin
        // By design, z_next asserted one cycle after 3rd w sample
        if (state == B && cycle_counter == 2) begin
            // sum the bits in w_shift plus current w (captured last shift)
            // Actually w_shift is shifted in previous cycle, so it contains last 3 w's
            // Count how many bits are 1
            // Use bitcount idiom
            integer i;
            integer ones_count;
            ones_count = 0;
            for (i=0; i<3; i=i+1)
                ones_count = ones_count + w_shift[i];

            if (ones_count == 2)
                z_next = 1'b1;
            else
                z_next = 1'b0;
        end else begin
            z_next = 1'b0;
        end
    end

endmodule