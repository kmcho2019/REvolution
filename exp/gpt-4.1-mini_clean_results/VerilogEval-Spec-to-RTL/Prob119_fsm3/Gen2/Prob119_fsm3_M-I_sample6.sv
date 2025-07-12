module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] current_state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Combined next state and output logic
    always @(*) begin
        // Default assignments
        next_state = 4'b0000;
        out = 1'b0;

        case (current_state)
            A: begin
                next_state = in ? B : A;
                out = 1'b0;
            end
            B: begin
                next_state = in ? B : C;
                out = 1'b0;
            end
            C: begin
                next_state = in ? D : A;
                out = 1'b0;
            end
            D: begin
                next_state = in ? B : C;
                out = 1'b1;
            end
            default: begin
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

endmodule