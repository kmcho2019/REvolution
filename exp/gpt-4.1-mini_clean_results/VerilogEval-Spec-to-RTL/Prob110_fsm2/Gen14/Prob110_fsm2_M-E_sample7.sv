module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding using 2 bits for extensibility
    localparam [1:0]
        OFF = 2'b00,
        ON  = 2'b01;

    reg [1:0] state, next_state;
    reg next_out;

    // Next state and output logic combinational
    always @(*) begin
        case(state)
            OFF: begin
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
                next_out = 1'b0;
            end
            ON: begin
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
                next_out = 1'b1;
            end
            default: begin
                next_state = OFF;
                next_out = 1'b0;
            end
        endcase
    end

    // State and output registers with synchronous active-high reset
    always @(posedge clk) begin
        if (areset) begin
            state <= OFF;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            out   <= next_out;
        end
    end

endmodule