module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Enumerate the states
reg [0:0] state;
localparam B = 1'b1;
localparam A = 1'b0;

always @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        case (state)
            B: begin
                if (!in) begin
                    state <= A;
                end
            end
            A: begin
                if (!in) begin
                    state <= B;
                end
            end
            default: state <= B;
        endcase
    end
end

always @(*) begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

endmodule