module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding using Gray coding
    localparam [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b100;

    reg [2:0] state;

    // State transition and reset logic
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
            case (state)
                A: state <= w ? A : B;
                B: state <= w ? D : C;
                C: state <= w ? D : E;
                D: state <= w ? A : F;
                E: state <= w ? D : E;
                F: state <= w ? D : C;
            endcase
        end
    end

    // Output logic
    assign z = state[2];  // MSB is 1 for E/F

endmodule