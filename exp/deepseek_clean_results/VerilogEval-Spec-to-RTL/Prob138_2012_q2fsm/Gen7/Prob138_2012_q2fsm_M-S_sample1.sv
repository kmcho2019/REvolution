module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    localparam [5:0] A = 6'b000001;
    localparam [5:0] B = 6'b000010;
    localparam [5:0] C = 6'b000100;
    localparam [5:0] D = 6'b001000;
    localparam [5:0] E = 6'b010000;
    localparam [5:0] F = 6'b100000;

    reg [5:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end
        else begin
            case (state)
                A: state <= w ? B : A;
                B: state <= w ? C : D;
                C: state <= w ? E : D;
                D: state <= w ? F : A;
                E: state <= w ? E : D;
                F: state <= w ? C : D;
                default: state <= A;
            endcase
            
            // Output is 1 for states E or F
            z <= (state == E) | (state == F);
        end
    end

endmodule