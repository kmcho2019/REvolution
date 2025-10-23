module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// State encoding
localparam A  = 2'b00;
localparam B0 = 2'b01;
localparam B1 = 2'b10;
localparam B2 = 2'b11;

reg [1:0] state, next_state;
reg [1:0] count_w;  // Counts how many times w=1 in the current 3-cycle period

// Sequential logic for state and count_w
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        count_w <= 2'd0;
        z <= 1'b0;
    end else begin
        state <= next_state;
        // In state B0,B1,B2 count the number of times w=1
        if (state == A) begin
            count_w <= 2'd0; // reset counter when in A
            z <= 1'b0;       // output 0 in state A
        end else begin
            // In states B0,B1,B2 update count_w
            if (w)
                count_w <= count_w + 1'b1;
            else
                count_w <= count_w;

            // Output z only at the cycle after B2, i.e., in B0 next cycle
            // We will generate z in the cycle after B2, which is B0 cycle.
            if (state == B2)
                z <= 1'b0; // output not updated here; updated next cycle (B0)
            else if (state == B0) begin
                // z depends on count_w from previous 3-cycle window
                // but count_w was reset at B0 start, so store count before resetting count_w
                // Instead, we generate z in B0 using count_w from previous cycle stored in count_w_reg
                // To do this correctly, we need to store the count_w from the last cycle B2 in a separate register.
                // So we will implement a separate register to hold count_w after B2 and generate z on B0.
            end else begin
                z <= 1'b0;
            end
        end
    end
end

// To handle z output correctly, create a register to hold the count at B2 cycle end
reg [1:0] count_w_last;

always @(posedge clk) begin
    if (reset) begin
        count_w_last <= 2'd0;
    end else begin
        if (state == B2) begin
            count_w_last <= count_w;
        end
    end
end

// Next state logic
always @(*) begin
    case(state)
        A: begin
            if (s == 1'b1)
                next_state = B0;
            else
                next_state = A;
        end
        B0: next_state = B1;
        B1: next_state = B2;
        B2: next_state = B0;
        default: next_state = A;
    endcase
end

// Output logic updated on posedge clk
// z output is 1 in B0 cycle if count_w_last == 2, else 0
always @(posedge clk) begin
    if (reset) begin
        z <= 1'b0;
    end else begin
        if (state == B0) begin
            if (count_w_last == 2)
                z <= 1'b1;
            else
                z <= 1'b0;
        end else if (state == A) begin
            z <= 1'b0;
        end else begin
            z <= 1'b0;
        end
    end
end

endmodule