module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot state encoding
    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;

    reg [3:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else begin
            case (1'b1) // priority encoding style for one-hot next state
                state[0]: state <= in ? B : A; // A state
                state[1]: state <= in ? B : C; // B state
                state[2]: state <= in ? D : A; // C state
                state[3]: state <= in ? B : C; // D state
                default:  state <= A;
            endcase
        end
    end

    assign out = state[3]; // output is 1 when in D state

endmodule