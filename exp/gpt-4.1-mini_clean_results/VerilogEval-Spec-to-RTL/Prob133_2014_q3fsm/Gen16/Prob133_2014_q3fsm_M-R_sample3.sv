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
    reg [1:0] w_count;  // 2-bit counter for number of w=1 samples in window

    // Combinational logic for next state
    always @(*) begin
        case(state)
            A:  next_state = s ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B0;
            default: next_state = A;
        endcase
    end

    // Compute total_count combinationally for output logic
    wire [2:0] total_count;
    assign total_count = w_count + (w ? 2'b01 : 2'b00);

    // Combinational logic for output z_next (registered output)
    // z asserted for one cycle immediately after 3rd sample (state B2)
    wire z_next;
    assign z_next = (state == B2) && (total_count == 3'd2);

    // Sequential logic: state and w_count registers
    always @(posedge clk) begin
        if (reset) begin
            state   <= A;
            w_count <= 2'b00;
            z       <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                A: begin
                    w_count <= 2'b00; // reset count in A
                    z       <= 1'b0;
                end

                B0: begin
                    // Start counting in B0 based on w
                    w_count <= (w ? 2'b01 : 2'b00);
                    z       <= 1'b0;
                end

                B1: begin
                    // Accumulate w_count
                    w_count <= w_count + (w ? 2'b01 : 2'b00);
                    z       <= 1'b0;
                end

                B2: begin
                    // After sampling 3rd w, output z depending on total_count
                    w_count <= 2'b00; // reset for next window
                    z       <= z_next; 
                end

                default: begin
                    w_count <= 2'b00;
                    z       <= 1'b0;
                end
            endcase
        end
    end

endmodule