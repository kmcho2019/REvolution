module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding (one-hot)
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state, next_state;

    // Combinational logic for next state and output (Mealy)
    always @* begin
        // Default assignments
        next_state = state;
        z = 1'b0;

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
                next_state = A;  // Safety: default to A
                z = 1'b0;
            end
        endcase
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

endmodule