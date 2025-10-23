module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0,
               B = 1'b1;

    reg state, next_state;

    // Counters for cycles and w count in B
    reg [1:0] cycle_count; // counts 0 to 2 (3 cycles)
    reg [1:0] w_count;     // counts how many times w=1 in these 3 cycles

    // Combinational sum of current w_count + w
    wire [2:0] total_w_count = w_count + w;

    // Sequential logic for state and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    // In A, counters and z are held at zero to reduce toggling
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
                B: begin
                    if (cycle_count < 2) begin
                        cycle_count <= cycle_count + 1'b1;
                        // Only increment w_count if w=1, else keep same value to reduce toggling
                        if (w)
                            w_count <= w_count + 1'b1;
                        // z low during counting cycles
                        z <= 1'b0;
                    end else begin
                        // On 3rd cycle, output z according to total count
                        z <= (total_w_count == 2) ? 1'b1 : 1'b0;
                        cycle_count <= 2'd0;
                        w_count <= 2'd0;
                    end
                end
            endcase
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

endmodule