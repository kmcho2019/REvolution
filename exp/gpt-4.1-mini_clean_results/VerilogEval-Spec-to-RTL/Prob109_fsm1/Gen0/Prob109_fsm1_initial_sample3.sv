module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                B: state <= (in == 1'b0) ? A : B;
                A: state <= (in == 1'b0) ? B : A;
                default: state <= B;  // safety default
            endcase
        end
    end

    // Moore output logic based on state
    always @(*) begin
        case (state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b0;
        endcase
    end

endmodule