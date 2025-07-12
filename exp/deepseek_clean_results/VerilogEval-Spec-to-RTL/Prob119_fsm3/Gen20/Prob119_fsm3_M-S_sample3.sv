module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Simple binary state encoding
    parameter [1:0] A = 2'b00,
                   B = 2'b01,
                   C = 2'b10,
                   D = 2'b11;

    reg [1:0] state;

    // State transition logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;  // Async reset to state A
        end
        else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
            endcase
        end
    end

    // Moore output depends only on current state
    assign out = (state == D);

endmodule