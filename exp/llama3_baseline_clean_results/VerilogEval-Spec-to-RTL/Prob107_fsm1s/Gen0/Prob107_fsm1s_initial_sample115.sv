module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state;  // Using 2 bits to represent the states
parameter A = 2'b01;
parameter B = 2'b10;

always @ (posedge clk) begin
    if (reset) begin  // Active high reset
        state <= B;
    end else begin
        case (state)
            B: begin
                if (~in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            A: begin
                if (~in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            default: state <= B;  // Default state
        endcase
    end
end

always @ (*) begin  // combinational logic for output
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;  // Default output
    endcase
end

endmodule