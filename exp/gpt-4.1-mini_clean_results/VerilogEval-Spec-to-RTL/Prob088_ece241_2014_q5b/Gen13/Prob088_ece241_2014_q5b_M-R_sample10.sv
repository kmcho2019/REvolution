module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // One-hot state encoding as parameters
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state, next_state;

    // Next state and output combinational logic
    always @(*) begin
        case (state)
            A: begin
                if (x == 1'b0) begin
                    next_state = A;
                    z = 1'b0;
                end else begin
                    next_state = B;
                    z = 1'b1;
                end
            end
            B: begin
                next_state = B;
                if (x == 1'b0)
                    z = 1'b1;
                else
                    z = 1'b0;
            end
            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

    // Sequential state update with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

endmodule