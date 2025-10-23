module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);
    // State encoding using localparam (2-bit)
    localparam [1:0]
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3;

    reg [1:0] current_state, next_state;

    // Asynchronous reset and state register update (posedge clk or areset)
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic combinational block
    always @(*) begin
        case (current_state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A;
        endcase
    end

    // Moore output logic combinational block
    always @(*) begin
        out = (current_state == D) ? 1'b1 : 1'b0;
    end

endmodule