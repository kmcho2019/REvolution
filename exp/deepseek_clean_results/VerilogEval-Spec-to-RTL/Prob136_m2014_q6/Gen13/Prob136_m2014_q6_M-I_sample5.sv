module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam [5:0] 
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state;
    wire clk_en = ~((state == E && ~w) || (state == A && w));

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else if (clk_en) begin
            casez (state) // synthesis parallel_case
                A: state <= w ? A : B;
                B: state <= w ? D : C;
                C: state <= w ? D : E;
                D: state <= w ? A : F;
                E: state <= w ? D : E;
                F: state <= w ? D : C;
                default: state <= A;
            endcase
        end
    end

    // Output is active in states E or F
    assign z = state[4] | state[5];

endmodule