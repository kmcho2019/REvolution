module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State representation using counter values
    // Each state corresponds to a unique count value
    localparam [2:0] A = 3'd0,
                     B = 3'd1,
                     C = 3'd2,
                     D = 3'd3,
                     E = 3'd4,
                     F = 3'd5;

    reg [2:0] state_count;

    // State transition logic using arithmetic operations
    always @(posedge clk) begin
        if (reset) begin
            state_count <= A;
        end else begin
            case (state_count)
                A: state_count <= w ? B : A;
                B: state_count <= w ? C : D;
                C: state_count <= w ? E : D;
                D: state_count <= w ? F : A;
                E: state_count <= w ? E : D;
                F: state_count <= w ? C : D;
                default: state_count <= A;
            endcase
        end
    end

    // Output logic - states E and F have count values >= 4
    assign z = (state_count >= E);

endmodule