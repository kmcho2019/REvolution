module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;
    
    reg [3:0] state;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A; // Reset to state A (one-hot)
        else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
                default: state <= A; // Fault recovery
            endcase
        end
    end

    // Output logic (direct bit check for state D)
    assign out = state[D];

endmodule