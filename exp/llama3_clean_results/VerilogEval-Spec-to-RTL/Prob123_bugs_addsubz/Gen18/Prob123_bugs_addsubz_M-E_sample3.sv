module accumulator #
(
    parameter WIDTH = 8
)
(
    input clk,
    input reset,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input do_sub,
    output reg [WIDTH-1:0] out,
    output reg result_is_zero
);

    reg [WIDTH-1:0] acc;
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            acc <= 0;
            state <= 0;
            out <= 0;
            result_is_zero <= 0;
        end else begin
            case (state)
                0: begin // idle state
                    if (do_sub) begin
                        state <= 1; // subtraction state
                        acc <= a;
                    end else begin
                        state <= 2; // addition state
                        acc <= a;
                    end
                end
                1: begin // subtraction state
                    acc <= acc - b;
                    state <= 3; // done state
                end
                2: begin // addition state
                    acc <= acc + b;
                    state <= 3; // done state
                end
                3: begin // done state
                    out <= acc;
                    result_is_zero <= ~(| acc);
                    state <= 0; // idle state
                end
            endcase
        end
    end

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    reg clk;
    reg reset;
    reg [7:0] b_selector;

    assign b_selector = do_sub? (~b + 1) : b;

    accumulator #(.WIDTH(8)) u_acc (
      .clk(clk),
      .reset(reset),
      .a(a),
      .b(b_selector),
      .do_sub(do_sub),
      .out(out),
      .result_is_zero(result_is_zero)
    );

    always @(posedge clk) begin
        clk <= ~clk;
    end

    initial begin
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
    end

endmodule