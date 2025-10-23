module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding with 2 bits
    localparam [1:0]
        A  = 2'b00, // Wait for s=1
        B0 = 2'b01, // First sample cycle in B
        B1 = 2'b10, // Second sample cycle in B
        B2 = 2'b11; // Third sample cycle in B

    reg [1:0] state, next_state;
    reg [1:0] w_count;  // counts how many times w=1 in current 3-cycle window

    // Combinational sum of w_count + w as total_count
    wire [2:0] total_count = w_count + w;

    // Next state combinational logic
    always @(*) begin
        case (state)
            A:  next_state = s ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B0;
            default: next_state = A;
        endcase
    end

    // Sequential logic for state, w_count and output z
    always @(posedge clk) begin
        if (reset) begin
            state   <= A;
            w_count <= 2'b00;
            z       <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    w_count <= 2'b00; // reset count in A
                    z       <= 1'b0;  // output zero in A
                end

                B0: begin
                    // Update count only if w=1, else keep zero (reduces toggling)
                    w_count <= w ? 2'b01 : 2'b00;
                    z       <= 1'b0;  // output zero until last sample
                end

                B1: begin
                    // Accumulate w_count
                    w_count <= w_count + (w ? 2'b01 : 2'b00);
                    z       <= 1'b0;
                end

                B2: begin
                    // On B2 output z=1 if total_count==2 else 0
                    z <= (total_count == 3'd2) ? 1'b1 : 1'b0;

                    w_count <= 2'b00; // reset count for next window
                end

                default: begin
                    w_count <= 2'b00;
                    z       <= 1'b0;
                end
            endcase
        end
    end

endmodule