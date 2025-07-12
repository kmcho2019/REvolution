module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding using localparam for clarity and scope limiting
    localparam A = 2'b00,
               B = 2'b01,
               C = 2'b10,
               D = 2'b11;

    reg [1:0] state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else begin
            case(state)
                A: state <= (in) ? B : A;
                B: state <= (in) ? B : C;
                C: state <= (in) ? D : A;
                D: state <= (in) ? B : C;
                default: state <= A;
            endcase
        end
    end

    // Combinational next state logic (optional if needed externally)
    wire [1:0] next_state = (state == A) ? (in ? B : A) :
                            (state == B) ? (in ? B : C) :
                            (state == C) ? (in ? D : A) :
                            (state == D) ? (in ? B : C) : A;

    // Moore output logic (depends only on current state)
    assign out = (state == D);

endmodule