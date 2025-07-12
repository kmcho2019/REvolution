module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding with descriptive parameters
    parameter [1:0] S_A = 2'b00,
                    S_B = 2'b01,
                    S_C = 2'b10,
                    S_D = 2'b11;

    reg [1:0] state;

    // State transition logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_A;  // Reset to state A
        end else begin
            case (state)
                S_A: state <= in ? S_B : S_A;
                S_B: state <= in ? S_B : S_C;
                S_C: state <= in ? S_D : S_A;
                S_D: state <= in ? S_B : S_C;
            endcase
        end
    end

    // Moore output - purely combinational
    assign out = (state == S_D);

endmodule