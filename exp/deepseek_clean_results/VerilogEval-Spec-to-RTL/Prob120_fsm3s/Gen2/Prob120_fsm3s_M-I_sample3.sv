module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Define one-hot state encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    // State register and output
    reg [3:0] state;
    assign out = (state == D);

    // Clock gating control
    reg last_in;
    wire clk_enable = (in != last_in) || reset;

    always @(posedge clk) begin
        last_in <= in;
    end

    // Combined state transition and register update with clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end
        else if (clk_enable) begin
            case (state) // synthesis parallel_case
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
                default: state <= A;
            endcase
        end
    end

endmodule