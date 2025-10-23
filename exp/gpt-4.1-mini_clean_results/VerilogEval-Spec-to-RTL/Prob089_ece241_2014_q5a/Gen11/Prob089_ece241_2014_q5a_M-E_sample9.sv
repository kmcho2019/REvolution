module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // FSM state encoding
    localparam COPY = 1'b0;   // Pass bits as-is until first '1'
    localparam INVERT = 1'b1; // Invert bits after first '1'

    reg state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            COPY: begin
                if (x == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            end
            INVERT: begin
                next_state = INVERT;
            end
            default: next_state = COPY;
        endcase
    end

    // Moore output logic: z = x XOR (state)
    assign z = x ^ state;

endmodule