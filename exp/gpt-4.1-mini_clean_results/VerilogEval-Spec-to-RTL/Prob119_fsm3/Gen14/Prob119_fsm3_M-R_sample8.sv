module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding using localparam for synthesis clarity
    localparam A = 2'b00,
               B = 2'b01,
               C = 2'b10,
               D = 2'b11;

    reg [1:0] state, next_state;

    // Sequential state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state and output logic using case and blocking assignments
    always @(*) begin
        // Default assignments to avoid latches
        next_state = state;
        out = 1'b0;

        case (state)
            A: begin
                next_state = (in) ? B : A;
                out = 1'b0;
            end
            B: begin
                next_state = (in) ? B : C;
                out = 1'b0;
            end
            C: begin
                next_state = (in) ? D : A;
                out = 1'b0;
            end
            D: begin
                next_state = (in) ? B : C;
                out = 1'b1;
            end
            default: begin
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

endmodule