module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    localparam CARRY    = 1'b0; // Carry (plus one) not yet added
    localparam NO_CARRY = 1'b1; // Carry consumed, invert bits now

    reg state;

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= CARRY;
        end else begin
            case(state)
                CARRY: state <= (x == 1'b1) ? NO_CARRY : CARRY;
                NO_CARRY: state <= NO_CARRY;
                default: state <= CARRY;
            endcase
        end
    end

    // Combinational output logic (Mealy output)
    always @(*) begin
        case(state)
            CARRY:    z = x;        // Copy input bits until first '1'
            NO_CARRY: z = ~x;       // Invert remaining bits
            default:  z = 1'b0;
        endcase
    end

endmodule