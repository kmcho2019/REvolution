module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Define states as parameters
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    // Combinational always block for state transition and output logic
    always @(*) begin
        case (state)
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
                next_state = 4'bxxxx;
                out = 1'b0;
            end
        endcase
    end

endmodule