module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized state encoding with direct output mapping
    reg [2:0] state;
    localparam A = 3'b000,
               B = 3'b001,
               C = 3'b010,
               D = 3'b011,
               E = 3'b100,
               F = 3'b101;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= w ? B : A;
                B: state <= w ? C : D;
                C: state <= w ? E : D;
                D: state <= w ? F : A;
                E: state <= w ? E : D;
                F: state <= w ? C : D;
                default: state <= A;
            endcase
        end
    end

    // Direct output mapping - E and F have state[2]=1
    assign z = state[2];

endmodule