module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // State registers with Gray encoding
    reg [1:0] current_state;
    localparam A = 2'b00, B = 2'b01, D = 2'b11, C = 2'b10;

    // State update and next state logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
            out <= 1'b0;
        end
        else begin
            case (current_state)
                A: current_state <= in ? B : A;
                B: current_state <= in ? B : C;
                C: current_state <= in ? D : A;
                D: current_state <= in ? B : C;
            endcase
            // Moore output based on next state (registered)
            out <= (current_state == D);
        end
    end

endmodule