module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

// State encoding
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

reg [1:0] state;

// Sequential logic: state transition and output generation
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        out <= 1'b0;
    end else begin
        case (state)
            A: begin
                state <= in ? B : A;
                out <= 1'b0;
            end
            B: begin
                state <= in ? B : C;
                out <= 1'b0;
            end
            C: begin
                state <= in ? D : A;
                out <= 1'b0;
            end
            D: begin
                state <= in ? B : C;
                out <= 1'b1;
            end
            default: begin
                state <= A;
                out <= 1'b0;
            end
        endcase
    end
end

endmodule