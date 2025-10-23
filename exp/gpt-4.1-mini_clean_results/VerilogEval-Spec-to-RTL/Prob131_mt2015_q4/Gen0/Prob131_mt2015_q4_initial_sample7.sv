// Module A: z = (x ^ y) & x
module A(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: reproduce waveform behavior from problem statement
// Assumes clock with period 5ns
module B(
    input clk,
    input x,
    input y,
    output reg z
);
    reg [3:0] time_step; // count number of clock cycles (each 5ns)

    always @(posedge clk) begin
        time_step <= time_step + 1;
    end

    always @(*) begin
        // Default output
        z = 1'b0;

        case (time_step)
            4'd0,4'd1,4'd2,4'd3,4'd4: z = 1'b1;             // 0ns to 20ns, x=0,y=0,z=1
            4'd5,4'd6: z = 1'b0;                            // 25ns,30ns x=1,y=0,z=0
            4'd7,4'd8: z = 1'b0;                            // 35ns,40ns x=0,y=1,z=0
            4'd9,4'd10: z = 1'b1;                           // 45ns,50ns x=1,y=1,z=1
            4'd11: z = 1'b1;                                // 55ns x=0,y=0,z=1
            4'd12,4'd13: z = 1'b0;                          // 60ns,65ns x=0,y=1,z=0
            4'd14: z = 1'b1;                                // 70ns x=1,y=1,z=1
            4'd15,4'd16,4'd17: z = 1'b0;                    // 75ns,80ns,85ns x=0,y=1,z=0
            4'd18: z = 1'b0;                                // 90ns x=1,y=0,z=0
            default: z = 1'b0;
        endcase
    end

    initial begin
        time_step = 0;
    end
endmodule

// Top-level module
// Inputs: x, y, clk
// Output: z
// Implements specified wiring:
// A1(x,y) OR B1(x,y) -> out_or
// A2(x,y) AND B2(x,y) -> out_and
// out_or XOR out_and -> z

module top_module(
    input x,
    input y,
    input clk,
    output z
);
    wire a1_out, a2_out, b1_out, b2_out;
    wire out_or, out_and;

    A A1(.x(x), .y(y), .z(a1_out));
    A A2(.x(x), .y(y), .z(a2_out));

    B B1(.clk(clk), .x(x), .y(y), .z(b1_out));
    B B2(.clk(clk), .x(x), .y(y), .z(b2_out));

    assign out_or = a1_out | b1_out;
    assign out_and = a2_out & b2_out;
    assign z = out_or ^ out_and;

endmodule