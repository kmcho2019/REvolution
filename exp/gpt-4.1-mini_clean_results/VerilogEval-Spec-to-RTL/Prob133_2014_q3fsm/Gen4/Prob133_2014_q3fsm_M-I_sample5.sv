module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // One-hot state encoding for 4 states: A, C0, C1, C2
    localparam [3:0]
        A  = 4'b0001, // Waiting for s=1
        C0 = 4'b0010, // Sample 1 of w
        C1 = 4'b0100, // Sample 2 of w
        C2 = 4'b1000; // Sample 3 of w and evaluate output

    reg [3:0] state, next_state;
    reg [1:0] w_count; // Counts how many w=1 in current 3-cycle window
    reg       z_next;

    // Combinational next state logic
    always @(*) begin
        case (state)
            A:  next_state = s ? C0 : A;
            C0: next_state = C1;
            C1: next_state = C2;
            C2: next_state = C0;
            default: next_state = A;
        endcase
    end

    // Combinational next w_count logic
    // w_count increments by w in C0 and C1, resets in A and C2
    // Implement w_count + w explicitly (since w_count is 2 bits and w is 1 bit)
    reg [1:0] w_count_next;
    always @(*) begin
        if (state == C0 || state == C1) begin
            // w_count + w without full adder:
            // sum = w_count + w
            // sum[0] = w_count[0] ^ w
            // carry = w_count[0] & w
            // sum[1] = w_count[1] ^ carry
            // no overflow expected for counting up to 3
            wire carry = w_count[0] & w;
            w_count_next[0] = w_count[0] ^ w;
            w_count_next[1] = w_count[1] ^ carry;
        end else begin
            w_count_next = 2'd0; // reset in A and C2
        end
    end

    // Combinational output logic for z_next: asserted only one cycle after C2 if exactly two w=1's
    always @(*) begin
        if (state == C2) begin
            // Evaluate if total w_count + w == 2
            // We'll reuse the addition logic for count
            wire carry = w_count[0] & w;
            wire [1:0] total;
            assign total[0] = w_count[0] ^ w;
            assign total[1] = w_count[1] ^ carry;
            z_next = (total == 2); // 2'b10 == 2 decimal
        end else begin
            z_next = 1'b0;
        end
    end

    // Sequential logic: state, w_count, z update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= w_count_next;

            // Update z only if it changes to reduce toggling
            if (z_next != z)
                z <= z_next;
        end
    end

endmodule