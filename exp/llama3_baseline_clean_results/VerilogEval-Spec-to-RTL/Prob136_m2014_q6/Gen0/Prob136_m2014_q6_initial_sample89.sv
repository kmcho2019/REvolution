module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
reg [3:0] state; // 4 bits can represent 6 states (A to F) with some states sharing the same value
localparam A = 4'b0000;
localparam B = 4'b0001;
localparam C = 4'b0010;
localparam D = 4'b0011;
localparam E = 4'b0100;
localparam F = 4'b0101;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
        z <= 0;
    end else begin
        case(state)
            A: begin
                if (!w) state <= B;
                else state <= A;
                z <= 0;
            end
            B: begin
                if (!w) state <= C;
                else state <= D;
                z <= 0;
            end
            C: begin
                if (!w) state <= E;
                else state <= D;
                z <= 0;
            end
            D: begin
                if (!w) state <= F;
                else state <= A;
                z <= 0;
            end
            E: begin
                if (w) state <= D;
                else state <= E;
                z <= 1;
            end
            F: begin
                if (w) state <= D;
                else state <= C;
                z <= 1;
            end
            default: state <= A;
        endcase
    end
end

endmodule