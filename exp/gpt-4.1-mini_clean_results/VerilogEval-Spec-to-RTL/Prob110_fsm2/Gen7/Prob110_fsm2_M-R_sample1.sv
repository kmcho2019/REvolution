module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Next state and output logic combined in a combinational block
    always @(*) begin
        case(state)
            OFF: begin
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
                // output for OFF state
                out = 1'b0;
            end
            ON: begin
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
                // output for ON state
                out = 1'b1;
            end
            default: begin
                next_state = OFF;
                out = 1'b0;
            end
        endcase
    end

    // State and output register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            out   <= out; // out is updated combinationally, so registered here
        end
    end

endmodule