module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding
    localparam [3:0] A = 4'b0001,
                    B = 4'b0010,
                    C = 4'b0100,
                    D = 4'b1000;

    reg [3:0] state;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end
        else begin
            case (1'b1)  // Synthesis will optimize this to parallel muxes
                state[A]: state <= in ? B : A;
                state[B]: state <= in ? B : C;
                state[C]: state <= in ? D : A;
                state[D]: state <= in ? B : C;
                default:  state <= A;
            endcase
        end
    end

    // Registered output (Moore output depends only on state)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;
        end
        else begin
            out <= (state == D);
        end
    end

endmodule