module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding with 2 bits to allow 4 states: A, B1, B2, B3
    localparam [1:0] 
        A  = 2'b00,
        B1 = 2'b01,
        B2 = 2'b10,
        B3 = 2'b11;

    reg [1:0] state, next_state;
    reg [1:0] count, next_count; // 2-bit counter to count w=1 occurrences in window

    always @(*) begin
        // Defaults
        next_state = state;
        next_count = count;
        z = 1'b0; // default output

        case(state)
            A: begin
                next_count = 2'd0;
                z = 1'b0;
                if (s)
                    next_state = B1;
                else
                    next_state = A;
            end
            B1: begin
                // Start new window, reset count with current w
                next_count = w ? 2'd1 : 2'd0;
                next_state = B2;
                z = 1'b0;
            end
            B2: begin
                // Accumulate w
                next_count = count + w;
                next_state = B3;
                z = 1'b0;
            end
            B3: begin
                // Accumulate w and produce output z next cycle
                // Actually output z in this cycle after accumulation
                // Add current w to count
                // We produce z based on count+w==2

                // Calculate total count including current w
                if (count + w == 2)
                    z = 1'b1;
                else
                    z = 1'b0;
                next_count = 2'd0;
                next_state = B1;
            end
            default: begin
                next_state = A;
                next_count = 2'd0;
                z = 1'b0;
            end
        endcase
    end

    // Sequential block to update state, count and register z synchronously
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            count <= next_count;
            z <= z;
        end
    end

endmodule