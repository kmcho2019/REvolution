module TopModule (
    input  clk,
    input  reset,  // synchronous active-high reset
    input  in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;
    reg out_next;

    // Combinational logic for next_state and combinational output (Moore output logic)
    always @(*) begin
        case (state)
            B: begin
                next_state = (in == 1'b0) ? A : B;
                out_next = 1'b1;
            end
            A: begin
                next_state = (in == 1'b0) ? B : A;
                out_next = 1'b0;
            end
            default: begin
                next_state = B;
                out_next = 1'b1;
            end
        endcase
    end

    // Synchronous state and output register with active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;
        end else begin
            state <= next_state;
            out <= out_next;
        end
    end

endmodule