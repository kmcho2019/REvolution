module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    // Define states
    reg state;
    parameter B = 1'b1;
    parameter A = 1'b0;

    // Look-up table for next state and output
    reg [1:0] lut_ns_out [1:0];
    initial begin
        lut_ns_out[B] = {B, 1'b1}; // B, out=1
        lut_ns_out[A] = {A, 1'b0}; // A, out=0
    end

    // Next state logic using LUT
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (in)
                1'b0: state <= (state == B)? A : B;
                1'b1: state <= (state == B)? B : A;
                default: state <= B;
            endcase
        end
    end

    // Output logic using LUT
    assign out = (state == B)? 1'b1 : 1'b0;

endmodule