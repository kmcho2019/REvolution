module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions: bits 31, 21, 1, and 0 (0-based)
    // We'll define a function to check if a bit is tapped
    function is_tapped;
        input integer bit_pos;
        begin
            case(bit_pos)
                31, 21, 1, 0: is_tapped = 1'b1;
                default:      is_tapped = 1'b0;
            endcase
        end
    endfunction

    integer i;
    reg feedback;
    reg [31:0] next_q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            feedback = q[0];
            // Shift right by 1
            next_q = q >> 1;
            // Conditionally flip tapped bits if feedback is 1
            if (feedback) begin
                for (i = 0; i < 32; i = i + 1) begin
                    if (is_tapped(i))
                        next_q[i] = ~next_q[i];
                end
            end
            q <= next_q;
        end
    end

endmodule