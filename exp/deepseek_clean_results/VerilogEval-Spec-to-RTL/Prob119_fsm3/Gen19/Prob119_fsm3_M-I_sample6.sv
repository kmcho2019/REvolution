module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Gray code state encoding maintained for power efficiency
    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    D = 2'b11,
                    C = 2'b10;

    reg [1:0] state;

    // synthesis parallel_case
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;  // Async reset to state A
        end else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;  // B and D both transition to C when in=0
                C: state <= in ? D : A;
                D: state <= in ? B : C;  // B and D both transition to C when in=0
            endcase
        end
    end

    // Output remains simple combinational logic
    assign out = (state == D);

endmodule