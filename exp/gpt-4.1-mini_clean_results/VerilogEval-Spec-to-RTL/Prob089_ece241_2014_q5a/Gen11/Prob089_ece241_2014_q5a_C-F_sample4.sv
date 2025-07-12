module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam WAIT_FOR_ONE = 1'b0;
    localparam INVERTING    = 1'b1;

    reg state;
    reg x_reg;

    // Sequential logic: asynchronous reset, state update, and input sampling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_FOR_ONE;
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
            case (state)
                WAIT_FOR_ONE: state <= (x_reg == 1'b1) ? INVERTING : WAIT_FOR_ONE;
                INVERTING:    state <= INVERTING;
                default:      state <= WAIT_FOR_ONE;
            endcase
        end
    end

    // Moore output logic: depends only on current registered state and input
    always @(*) begin
        case (state)
            WAIT_FOR_ONE: z = x_reg;      // copy input bit until first 1
            INVERTING:    z = ~x_reg;     // invert bits after first 1
            default:      z = 1'b0;
        endcase
    end

endmodule