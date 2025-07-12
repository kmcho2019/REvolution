module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State registers with direct encoding
    reg [1:0] current_state;
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // State update and next state logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else case (current_state)
            A: current_state <= in ? B : A;
            B: current_state <= in ? B : C;
            C: current_state <= in ? D : A;
            D: current_state <= in ? B : C;
        endcase
    end

    // Output logic
    assign out = (current_state == D);

endmodule