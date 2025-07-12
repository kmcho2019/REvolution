module TopModule (
    input x,
    input y,
    output reg z
);
    reg [1:0] prev_state;
    wire [1:0] current_state = {x, y};
    wire single_change = (current_state[0] ^ prev_state[0]) ^ 
                        (current_state[1] ^ prev_state[1]);

    always @* begin
        case(current_state)
            2'b00, 2'b11: z = ~single_change;
            default: z = 1'b0;
        endcase
    end

    always @* begin
        prev_state = current_state;
    end
endmodule