module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding parameters
    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    C = 2'b10,
                    D = 2'b11;

    // State registers
    reg [1:0] current_state;

    // Moore output (depends only on current state)
    assign out = (current_state == D);

    // Combined state transition and update logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            case (current_state)
                A: current_state <= in ? B : A;
                B: current_state <= in ? B : C;
                C: current_state <= in ? D : A;
                D: current_state <= in ? B : C;
            endcase
        end
    end

endmodule