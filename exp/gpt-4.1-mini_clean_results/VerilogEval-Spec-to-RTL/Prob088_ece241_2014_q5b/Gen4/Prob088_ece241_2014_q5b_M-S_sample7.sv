module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding: 2'b01 = A, 2'b10 = B (one-hot)
    reg [1:0] state, next_state;

    // Next state and output logic combined (combinational)
    always @(*) begin
        case (state)
            2'b01: begin // A
                z = x;
                next_state = x ? 2'b10 : 2'b01;
            end
            2'b10: begin // B
                z = ~x;
                next_state = 2'b10;
            end
            default: begin // default/reset state
                z = 0;
                next_state = 2'b01;
            end
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // reset to A
        else
            state <= next_state;
    end

endmodule