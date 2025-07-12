module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg [3:0] state;  // One-hot encoding: A=0001, B=0010, C=0100, D=1000
    reg last_in;
    wire clk_enable = (in != last_in);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001;  // Reset to state A
            last_in <= 1'b0;
        end
        else if (clk_enable) begin
            last_in <= in;
            case (1'b1)  // Synopsys parallel_case
                state[0]: state <= in ? 4'b0010 : 4'b0001;  // A
                state[1]: state <= in ? 4'b0010 : 4'b0100;  // B
                state[2]: state <= in ? 4'b1000 : 4'b0001;  // C
                state[3]: state <= in ? 4'b0010 : 4'b0100;  // D
                default:  state <= 4'b0001;
            endcase
        end
    end

    assign out = state[3];  // Output is 1 only in state D

endmodule