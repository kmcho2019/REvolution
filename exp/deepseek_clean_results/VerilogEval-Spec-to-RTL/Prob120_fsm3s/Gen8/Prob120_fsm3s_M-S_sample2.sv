module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Parameterized state encoding
    parameter [1:0] A = 2'b00;
    parameter [1:0] B = 2'b01;
    parameter [1:0] C = 2'b10;
    parameter [1:0] D = 2'b11;

    reg [1:0] current_state;

    // Output is high only in state D
    assign out = (current_state == D);

    // Combined state transition and update logic
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else begin
            case (current_state)
                A: current_state <= in ? B : A;
                B: current_state <= in ? B : C;
                C: current_state <= in ? D : A;
                D: current_state <= in ? B : C;
            endcase
        end
    end

endmodule