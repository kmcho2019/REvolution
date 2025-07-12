module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // State encoding
    localparam [1:0] OFF = 2'b00,
                     ON  = 2'b01;

    reg [1:0] state, next_state;

    // Next state and output logic
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

    // State and output register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= out;
        end
    end

endmodule