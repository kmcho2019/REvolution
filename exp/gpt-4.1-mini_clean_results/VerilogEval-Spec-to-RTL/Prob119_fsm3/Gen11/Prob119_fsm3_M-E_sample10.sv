module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding using localparam for synthesis friendliness
    localparam A = 2'd0,
               B = 2'd1,
               C = 2'd2,
               D = 2'd3;

    reg [1:0] state, next_state;

    // Synchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output depends only on current state
            out <= (next_state == D) ? 1'b1 : 1'b0;
        end
    end

    // Combinational next-state logic and output logic combined
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

endmodule