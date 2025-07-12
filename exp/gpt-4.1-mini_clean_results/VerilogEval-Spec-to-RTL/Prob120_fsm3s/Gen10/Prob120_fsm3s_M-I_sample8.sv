module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding as parameters
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state, next_state;
    reg next_out;

    // Combinational next state and output logic using case statement
    always @(*) begin
        next_state = A;
        next_out = 1'b0;
        case (state)
            A: begin
                next_state = (in == 1'b0) ? A : B;
                next_out = 1'b0;
            end
            B: begin
                next_state = (in == 1'b0) ? C : B;
                next_out = 1'b0;
            end
            C: begin
                next_state = (in == 1'b0) ? A : D;
                next_out = 1'b0;
            end
            D: begin
                next_state = (in == 1'b0) ? C : B;
                next_out = 1'b1;
            end
            default: begin
                next_state = A;
                next_out = 1'b0;
            end
        endcase
    end

    // Sequential state and output register update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= next_out;
        end
    end

endmodule