module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // Function to compute next y[1] bit based on current state and input w
    function automatic logic next_y1(input [2:0] state, input w_in);
        begin
            case (state)
                3'b000: next_y1 = 1'b0;              // A -> A or B (both y1=0)
                3'b001: next_y1 = 1'b1;              // B -> C or D (both y1=1)
                3'b010: next_y1 = w_in ? 1'b1 : 1'b0; // C -> D(y1=1) if w=1 else E(y1=0)
                3'b011: next_y1 = 1'b0;              // D -> A or F (both y1=0)
                3'b100: next_y1 = w_in ? 1'b1 : 1'b0; // E -> D(y1=1) if w=1 else E(y1=0)
                3'b101: next_y1 = 1'b1;              // F -> D or C (both y1=1)
                default: next_y1 = 1'b0;             // Default safe state
            endcase
        end
    endfunction

    assign Y1 = next_y1(y, w);

endmodule