module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding
    localparam [1:0] OFF = 2'b00;
    localparam [1:0] ON  = 2'b01;

    reg [1:0] state, next_state;

    // Next state and output logic combined with synchronous reset
    always @(posedge clk) begin
        if (areset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            case (state)
                OFF: begin
                    if (j)
                        next_state = ON;
                    else
                        next_state = OFF;
                    out <= 1'b0;
                end
                ON: begin
                    if (k)
                        next_state = OFF;
                    else
                        next_state = ON;
                    out <= 1'b1;
                end
                default: begin
                    next_state = OFF;
                    out <= 1'b0;
                end
            endcase
            state <= next_state;
        end
    end

endmodule