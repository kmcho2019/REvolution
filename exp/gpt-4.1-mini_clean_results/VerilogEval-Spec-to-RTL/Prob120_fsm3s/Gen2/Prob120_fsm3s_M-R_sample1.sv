module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding as localparams
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;
    reg next_out;

    // Next state and output logic (combinational)
    always @(*) begin
        case (state)
            A: begin
                next_state = in ? B : A;
                next_out = 1'b0;
            end
            B: begin
                next_state = in ? B : C;
                next_out = 1'b0;
            end
            C: begin
                next_state = in ? D : A;
                next_out = 1'b0;
            end
            D: begin
                next_state = in ? B : C;
                next_out = 1'b1;
            end
            default: begin
                next_state = A;
                next_out = 1'b0;
            end
        endcase
    end

    // State and output registers with synchronous reset
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