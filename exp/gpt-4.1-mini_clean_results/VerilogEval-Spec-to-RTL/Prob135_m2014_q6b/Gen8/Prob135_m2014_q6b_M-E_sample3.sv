module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Function to compute next y[1] based on current state y and input w
    function automatic next_y1_func;
        input [2:0] state;
        input       in_w;
        reg   next_y1_val;
        begin
            case ({state, in_w})
                // State A (000)
                4'b0000: next_y1_val = 0; // A with w=0: next state B(001), y1=0
                4'b0001: next_y1_val = 0; // A with w=1: next state A(000), y1=0

                // State B (001)
                4'b0010: next_y1_val = 0; // B with w=0: next state C(010), y1=1
                4'b0011: next_y1_val = 1; // B with w=1: next state D(011), y1=1

                // State C (010)
                4'b0100: next_y1_val = 1; // C with w=0: next state E(100), y1=0
                4'b0101: next_y1_val = 1; // C with w=1: next state D(011), y1=1

                // State D (011)
                4'b0110: next_y1_val = 1; // D with w=0: next state F(101), y1=0
                4'b0111: next_y1_val = 0; // D with w=1: next state A(000), y1=0

                // State E (100)
                4'b1000: next_y1_val = 0; // E with w=0: next state E(100), y1=0
                4'b1001: next_y1_val = 1; // E with w=1: next state D(011), y1=1

                // State F (101)
                4'b1010: next_y1_val = 1; // F with w=0: next state C(010), y1=1
                4'b1011: next_y1_val = 1; // F with w=1: next state D(011), y1=1

                // Default for all other cases
                default: next_y1_val = 0;
            endcase
            next_y1_func = next_y1_val;
        end
    endfunction

    assign Y1 = next_y1_func(y, w);

endmodule