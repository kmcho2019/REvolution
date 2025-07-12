module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // Combined next state and output logic
    always @(*) begin
        case (state)
            B: begin
                if (in == 1'b0) 
                    next_state = A;
                else 
                    next_state = B;
                out = 1'b1;
            end
            A: begin
                if (in == 1'b0) 
                    next_state = B;
                else 
                    next_state = A;
                out = 1'b0;
            end
            default: begin
                next_state = B;
                out = 1'b1;
            end
        endcase
    end

    // State and output update on clock, synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;
        end else begin
            state <= next_state;
            out <= out; // out updated combinationally in previous always block
        end
    end

endmodule