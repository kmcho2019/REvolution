module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding
    localparam [1:0] OFF = 2'b01;
    localparam [1:0] ON  = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output logic (registered output)
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else begin
            case(state)
                OFF: out <= 1'b0;
                ON:  out <= 1'b1;
                default: out <= 1'b0;
            endcase
        end
    end

endmodule