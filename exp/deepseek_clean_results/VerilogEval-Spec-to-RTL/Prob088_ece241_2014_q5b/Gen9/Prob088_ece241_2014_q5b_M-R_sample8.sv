module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding
    parameter [1:0] STATE_A = 2'b01;
    parameter [1:0] STATE_B = 2'b10;
    
    reg [1:0] state;

    // State transitions
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_A;
        end else begin
            case (state)
                STATE_A: state <= x ? STATE_B : STATE_A;
                STATE_B: state <= STATE_B; // Always stay in B once entered
                default: state <= STATE_A;
            endcase
        end
    end

    // Output logic (Mealy machine)
    assign z = (state == STATE_A) ? x : ~x;

endmodule