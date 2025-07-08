module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // One-hot encoded states
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state, next_state;

    // Asynchronous reset and synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic and output logic (Mealy)
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
                if (x == 1'b0) begin
                    next_state = B;
                    z = 1'b1;
                end else begin
                    next_state = B;
                    z = 1'b0;
                end
            end

            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

endmodule