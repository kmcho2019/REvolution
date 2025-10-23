module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding (2 bits)
    localparam [1:0]
        A  = 2'b00, // Wait for s=1
        B0 = 2'b01, // First sample cycle in B
        B1 = 2'b10, // Second sample cycle in B
        B2 = 2'b11; // Third sample cycle in B

    reg [1:0] state, next_state;
    reg [1:0] w_count;  // counts how many times w=1 in current 3-cycle window

    // Next state logic
    always @(*) begin
        case (state)
            A:  next_state = s ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B0;
            default: next_state = A;
        endcase
    end

    // Sequential logic: state, w_count, and output z
    always @(posedge clk) begin
        if (reset) begin
            state   <= A;
            w_count <= 2'b00;
            z       <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    w_count <= 2'b00;
                    z       <= 1'b0;
                end
                B0: begin
                    w_count <= w ? 2'b01 : 2'b00;
                    z       <= 1'b0;
                end
                B1: begin
                    w_count <= w_count + (w ? 2'b01 : 2'b00);
                    z       <= 1'b0;
                end
                B2: begin
                    // Compute total count of w=1 in 3 samples
                    // Using a wire for sum in combinational way
                    wire [2:0] total = w_count + (w ? 2'b01 : 2'b00);
                    w_count <= 2'b00;
                    z <= (total == 3'd2) ? 1'b1 : 1'b0;
                end
                default: begin
                    w_count <= 2'b00;
                    z       <= 1'b0;
                end
            endcase
        end
    end

endmodule