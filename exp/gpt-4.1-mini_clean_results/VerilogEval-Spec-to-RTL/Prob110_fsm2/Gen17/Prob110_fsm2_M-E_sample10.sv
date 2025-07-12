module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding (using 2 bits for demonstration)
    localparam OFF = 2'b00;
    localparam ON  = 2'b01;

    reg [1:0] state, next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output logic registered on clock
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else begin
            case (state)
                OFF: out <= 1'b0;
                ON:  out <= 1'b1;
                default: out <= 1'b0;
            endcase
        end
    end

endmodule