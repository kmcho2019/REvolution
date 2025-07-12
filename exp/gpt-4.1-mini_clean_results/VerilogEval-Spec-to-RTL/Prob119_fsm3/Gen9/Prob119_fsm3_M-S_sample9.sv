module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    localparam [1:0] A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    reg [1:0] state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state and output logic combined
    always @(*) begin
        case(state)
            A: begin
                next_state = in ? B : A;
                out = 1'b0;
            end
            B: begin
                next_state = in ? B : C;
                out = 1'b0;
            end
            C: begin
                next_state = in ? D : A;
                out = 1'b0;
            end
            D: begin
                next_state = in ? B : C;
                out = 1'b1;
            end
            default: begin
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

endmodule