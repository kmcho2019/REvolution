module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding
    parameter [1:0] A = 2'b00,
                   B = 2'b01,
                   C = 2'b10,
                   D = 2'b11;

    reg [1:0] state;

    // State register with async reset and next state logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end
        else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
                default: state <= A;
            endcase
            
            // Registered output (Moore machine)
            out <= (state == D);
        end
    end

endmodule