module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Combinational next state and output logic
    always @(*) begin
        next_state = current_state; // default hold
        out = 1'b0;                 // default output

        case (current_state)
            A: begin
                next_state = (in) ? B : A;
                out = 1'b0;
            end
            B: begin
                next_state = (in) ? B : C;
                out = 1'b0;
            end
            C: begin
                next_state = (in) ? D : A;
                out = 1'b0;
            end
            D: begin
                next_state = (in) ? B : C;
                out = 1'b1;
            end
            default: begin
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

    // Sequential state register with asynchronous reset, output registered as Moore output
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
            out <= 1'b0;
        end else begin
            current_state <= next_state;
            // out is updated in combinational block, so latch here to register output
            out <= out;
        end
    end

endmodule